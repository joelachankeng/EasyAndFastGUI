//+------------------------------------------------------------------+
//|                                                     ListView.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "Scrolls.mqh"
//+------------------------------------------------------------------+
//| Class for creating a list view                                   |
//+------------------------------------------------------------------+
class CListView : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Pointer to the element managing the list view visibility
   CElement         *m_combobox;
   //--- Objects for creating the list view
   CRectLabel        m_area;
   CEdit             m_items[];
   CScrollV          m_scrollv;
   //--- Array of the list view values
   string            m_value_items[];
   //--- Size of the list view and its visible part
   int               m_items_total;
   int               m_visible_items_total;
   //--- (1) Index and (2) the text of the highlighted item
   int               m_selected_item_index;
   string            m_selected_item_text;
   //--- Properties of the list view background
   int               m_area_zorder;
   color             m_area_border_color;
   //--- Properties of the list view items
   int               m_item_zorder;
   int               m_item_y_size;
   color             m_item_color;
   color             m_item_color_hover;
   color             m_item_color_selected;
   color             m_item_text_color;
   color             m_item_text_color_hover;
   color             m_item_text_color_selected;
   //--- Mode of alignment of the text in the list view
   ENUM_ALIGN_MODE   m_align_mode;
   //--- Mode of highlighting when the cursor is hovering over
   bool              m_lights_hover;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CListView(void);
                    ~CListView(void);
   //--- Methods for creating the list view
   bool              CreateListView(const long chart_id,const int window,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateList(void);
   bool              CreateScrollV(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) stores the combobox pointer, (3) returns the scrollbar pointer
   void              WindowPointer(CWindow &object)                      { m_wnd=::GetPointer(object);      }
   void              ComboBoxPointer(CElement &object)                   { m_combobox=::GetPointer(object); }
   CScrollV         *GetScrollVPointer(void)                             { return(::GetPointer(m_scrollv)); }
   //--- (1) Item height, returns (2) the size of the list view and (3) its visible part
   void              ItemYSize(const int y_size)                         { m_item_y_size=y_size;            }
   int               ItemsTotal(void)                              const { return(m_items_total);           }
   int               VisibleItemsTotal(void)                       const { return(m_visible_items_total);   }
   //--- State of the scrollbar
   bool              ScrollState(void)                             const { return(m_scrollv.ScrollState()); }
   //--- (1) Background frame color, (2) mode of highlighting items when hovering, (3) text alignment mode
   void              AreaBorderColor(const color clr)                    { m_area_border_color=clr;         }
   void              LightsHover(const bool state)                       { m_lights_hover=state;            }
   void              TextAlign(const ENUM_ALIGN_MODE align_mode)         { m_align_mode=align_mode;         }
   //--- Color of the list view items in different states
   void              ItemColor(const color clr)                          { m_item_color=clr;                }
   void              ItemColorHover(const color clr)                     { m_item_color_hover=clr;          }
   void              ItemColorSelected(const color clr)                  { m_item_color_selected=clr;       }
   void              ItemTextColor(const color clr)                      { m_item_text_color=clr;           }
   void              ItemTextColorHover(const color clr)                 { m_item_text_color_hover=clr;     }
   void              ItemTextColorSelected(const color clr)              { m_item_text_color_selected=clr;  }
   //--- Returns/stores (1) the index and (2) the text in the highlighted item in the list view
   void              SelectedItemByIndex(const int index);
   int               SelectedItemIndex(void)                       const { return(m_selected_item_index);   }
   string            SelectedItemText(void)                        const { return(m_selected_item_text);    }
   //--- Setting the value in the list view by the specified index of the row
   void              ValueToList(const int item_index,const string value);
   //--- Set the size of (1) the list view and (2) its visible part
   void              ListSize(const int items_total);
   void              VisibleListSize(const int visible_items_total);
   //--- (1) Resetting the color of the list view items, (2) changing the color of the list view items when the cursor is hovering over them
   void              ResetItemsColor(void);
   void              ChangeItemsColor(const int x,const int y);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- (1) Set, (2) reset priorities of the left mouse button press
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //---
private:
   //--- Handling the pressing on the list view item
   bool              OnClickListItem(const string clicked_object);
   //--- Scrolling the list view
   void              ShiftList(void);
   //--- Highlighting of the selected item
   void              HighlightSelectedItem(void);
   //--- Fast forward of the list view
   void              FastSwitching(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CListView::CListView(void) : m_item_y_size(18),
                             m_lights_hover(false),
                             m_align_mode(ALIGN_LEFT),
                             m_items_total(2),
                             m_visible_items_total(2),
                             m_selected_item_index(WRONG_VALUE),
                             m_selected_item_text(""),
                             m_area_border_color(C'235,235,235'),
                             m_item_color(clrWhite),
                             m_item_color_hover(C'240,240,240'),
                             m_item_color_selected(C'51,153,255'),
                             m_item_text_color(clrBlack),
                             m_item_text_color_hover(clrBlack),
                             m_item_text_color_selected(clrWhite)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_area_zorder =1;
   m_item_zorder =2;
//--- Set the size of the list view and its visible part
   ListSize(m_items_total);
   VisibleListSize(m_visible_items_total);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CListView::~CListView(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CListView::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling of the cursor movement event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the element is hidden
      if(!CElement::IsVisible())
         return;
      //--- Leave, if numbers of subwindows do not match
      if(CElement::m_subwin!=CElement::m_mouse.SubWindowNumber())
         return;
      //--- Checking the focus over the list view
      CElement::MouseFocus(m_mouse.X()>CElement::X() && m_mouse.X()<CElement::X2() && 
                           m_mouse.Y()>CElement::Y() && m_mouse.Y()<CElement::Y2());
      //--- If this is a drop-down list and the mouse button is pressed
      if(CElement::IsDropdown() && m_mouse.LeftButtonState())
        {
         //--- If the cursor is outside the combobox, outside the list view and not in scrolling mode
         if(!m_combobox.MouseFocus() && !CElement::MouseFocus() && !m_scrollv.ScrollState())
           {
            //--- Hide the list view
            Hide();
            return;
           }
        }
      //--- Move the list if the management of the slider is enabled
      if(m_scrollv.ScrollBarControl(m_mouse.X(),m_mouse.Y(),m_mouse.LeftButtonState()))
         ShiftList();
      //--- Changes the color of the list view items when the cursor is hovering over it
      ChangeItemsColor(m_mouse.X(),m_mouse.Y());
      return;
     }
//--- Handling the pressing on objects
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- If the pressing was on the list view elements
      if(OnClickListItem(sparam))
        {
         //--- Highlighting the item
         HighlightSelectedItem();
         return;
        }
      //--- If the pressing was on the buttons of the scrollbar
      if(m_scrollv.OnClickScrollInc(sparam) || m_scrollv.OnClickScrollDec(sparam))
        {
         //--- Moves the list along the scrollbar
         ShiftList();
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CListView::OnEventTimer(void)
  {
//--- If the element is a drop-down
   if(CElement::IsDropdown())
      //--- Fast forward of the list view
      FastSwitching();
//--- If this is not a drop-down element, take current availability of the form into consideration
   else
     {
      //--- Track the fast forward of the list view only if the form is not blocked
      if(!m_wnd.IsLocked())
         FastSwitching();
     }
  }
//+------------------------------------------------------------------+
//| Creates the list view                                            |
//+------------------------------------------------------------------+
bool CListView::CreateListView(const long chart_id,const int subwin,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- If the list view is a drop-down, a pointer to the combobox to which it will be attached is required
   if(CElement::IsDropdown())
     {
      //--- Leave, if there is no pointer to the combobox
      if(::CheckPointer(m_combobox)==POINTER_INVALID)
        {
         ::Print(__FUNCTION__," > Before creating a drop-down list view, the class must be passed "
                 "a pointer to the combobox: CListView::ComboBoxPointer(CElement &object)");
         return(false);
        }
     }
//--- Initializing variables
   m_id                  =m_wnd.LastId()+1;
   m_chart_id            =chart_id;
   m_subwin              =subwin;
   m_x                   =x;
   m_y                   =y;
   m_y_size              =m_item_y_size*m_visible_items_total-(m_visible_items_total-1)+2;
   m_selected_item_index =(m_selected_item_index==WRONG_VALUE) ? 0 : m_selected_item_index;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating a button
   if(!CreateArea())
      return(false);
   if(!CreateList())
      return(false);
   if(!CreateScrollV())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the list view background                                  |
//+------------------------------------------------------------------+
bool CListView::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_listview_area_"+(string)CElement::Id();
//--- Creating the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_item_color);
   m_area.Color(m_area_border_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Store coordinates
   m_area.X(CElement::X());
   m_area.Y(CElement::Y());
//--- Store the size
   m_area.XSize(CElement::XSize());
   m_area.YSize(CElement::YSize());
//--- Margins from the edge
   m_area.XGap(m_x-m_wnd.X());
   m_area.YGap(m_y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the list view items                                      |
//+------------------------------------------------------------------+
bool CListView::CreateList(void)
  {
//--- Coordinates
   int x =CElement::X()+1;
   int y =0;
//--- Calculating the width of the list view items
   int w=(m_items_total>m_visible_items_total) ? CElement::XSize()-m_scrollv.ScrollWidth() : CElement::XSize()-2;
//---
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- Forming the object name
      string name=CElement::ProgramName()+"_listview_edit_"+(string)i+"__"+(string)CElement::Id();
      //--- Calculating the Y coordinate
      y=(i>0) ? y+m_item_y_size-1 : CElement::Y()+1;
      //--- Creating the object
      if(!m_items[i].Create(m_chart_id,name,m_subwin,x,y,w,m_item_y_size))
         return(false);
      //--- Setting the properties
      m_items[i].Description(m_value_items[i]);
      m_items[i].TextAlign(m_align_mode);
      m_items[i].Font(FONT);
      m_items[i].FontSize(FONT_SIZE);
      m_items[i].Color(m_item_text_color);
      m_items[i].BackColor(m_item_color);
      m_items[i].BorderColor(m_item_color);
      m_items[i].Corner(m_corner);
      m_items[i].Anchor(m_anchor);
      m_items[i].Selectable(false);
      m_items[i].Z_Order(m_item_zorder);
      m_items[i].ReadOnly(true);
      m_items[i].Tooltip("\n");
      //--- Coordinates
      m_items[i].X(x);
      m_items[i].Y(y);
      //--- Size
      m_items[i].XSize(w);
      m_items[i].YSize(m_item_y_size);
      //--- Margins from the edge of the panel
      m_items[i].XGap(x-m_wnd.X());
      m_items[i].YGap(y-m_wnd.Y());
      //--- Store the object pointer
      CElement::AddToArray(m_items[i]);
     }
//--- Highlighting the selected item
   HighlightSelectedItem();
//--- Moves the list along the scrollbar
   ShiftList();
//--- Store the text of the selected item
   m_selected_item_text=m_value_items[m_selected_item_index];
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the vertical scrollbar                                   |
//+------------------------------------------------------------------+
bool CListView::CreateScrollV(void)
  {
//--- If the number of items is greater that the size of the list then
//    set the vertical scrolling
   if(m_items_total<=m_visible_items_total)
      return(true);
//--- Store the form pointer
   m_scrollv.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X()+m_area.X_Size()-m_scrollv.ScrollWidth();
   int y=CElement::Y();
//--- set properties
   m_scrollv.Id(CElement::Id());
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(CElement::YSize());
   m_scrollv.AreaBorderColor(m_area_border_color);
   m_scrollv.IsDropdown(CElement::IsDropdown());
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(m_chart_id,m_subwin,x,y,m_items_total,m_visible_items_total))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Storing the index                                                |
//+------------------------------------------------------------------+
void CListView::SelectedItemByIndex(const int index)
  {
//--- Adjustment in case the range has been exceeded
   m_selected_item_index=(index>=m_items_total)? m_items_total-1 :(index<0)? 0 : index;
//--- Highlighting the selected item
   HighlightSelectedItem();
//--- Moves the list along the scrollbar
   ShiftList();
//--- Store the text of the selected item
   m_selected_item_text=m_value_items[m_selected_item_index];
  }
//+------------------------------------------------------------------+
//| Stores the passed value in the list view by the specified index  |
//+------------------------------------------------------------------+
void CListView::ValueToList(const int item_index,const string value)
  {
   int array_size=::ArraySize(m_value_items);
//--- If there are no items in the context menu, report
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "when the list view contains at least one item!");
     }
//--- Adjustment in case the range has been exceeded
   int i=(item_index>=array_size)? array_size-1 :(item_index<0)? 0 : item_index;
//--- Store the value in the list view
   m_value_items[i]=value;
   ShiftList();
  }
//+------------------------------------------------------------------+
//| Sets the size of the list view                                   |
//+------------------------------------------------------------------+
void CListView::ListSize(const int items_total)
  {
//--- No point to make a list view shorter than two items
   m_items_total=(items_total<2) ? 2 : items_total;
   ::ArrayResize(m_value_items,m_items_total);
  }
//+------------------------------------------------------------------+
//| Sets the size of the visible part of the list view               |
//+------------------------------------------------------------------+
void CListView::VisibleListSize(const int visible_items_total)
  {
//--- No point to make a list view shorter than two items
   m_visible_items_total=(visible_items_total<2) ? 2 : visible_items_total;
   ::ArrayResize(m_items,m_visible_items_total);
  }
//+------------------------------------------------------------------+
//| Resetting the color of the list view items                       |
//+------------------------------------------------------------------+
void CListView::ResetItemsColor(void)
  {
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Iterate over the visible part of the list view
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- Increase the counter if the list view range has not been exceeded
      if(v>=0 && v<m_items_total)
         v++;
      //--- Skip the selected item
      if(m_selected_item_index==v-1)
         continue;
      //--- Setting the color (background, text)
      m_items[i].BackColor(m_item_color);
      m_items[i].Color(m_item_text_color);
     }
  }
//+------------------------------------------------------------------+
//| Changing color of the list view item when the cursor is hovering |
//+------------------------------------------------------------------+
void CListView::ChangeItemsColor(const int x,const int y)
  {
//--- Leave, if the highlighting of the item when the cursor is hovering over it is disabled or the scrollbar is active
   if(!m_lights_hover || m_scrollv.ScrollState())
      return;
//--- Leave, if it is not a drop-down element and the form is blocked
   if(!CElement::IsDropdown() && m_wnd.IsLocked())
      return;
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Identify over which item the cursor is over and highlight it
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- Increase the counter if the list view range has not been exceeded
      if(v>=0 && v<m_items_total)
         v++;
      //--- Skip the selected item
      if(m_selected_item_index==v-1)
        {
         m_items[i].BackColor(m_item_color_selected);
         m_items[i].Color(m_item_text_color_selected);
         continue;
        }
      //--- If the cursor is over this item, highlight it
      if(x>m_items[i].X() && x<m_items[i].X2() && y>m_items[i].Y() && y<m_items[i].Y2())
        {
         m_items[i].BackColor(m_item_color_hover);
         m_items[i].Color(m_item_text_color_hover);
        }
      //--- If the cursor is not over this item, assign the color appropriate to its state
      else
        {
         m_items[i].BackColor(m_item_color);
         m_items[i].Color(m_item_text_color);
        }
     }
  }
//+------------------------------------------------------------------+
//| Moves the list view along the scrollbar                          |
//+------------------------------------------------------------------+
void CListView::ShiftList(void)
  {
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Iterate over the visible part of the list view
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- If inside the range of the list view
      if(v>=0 && v<m_items_total)
        {
         //--- Moving the text, the background color and the text color
         m_items[i].Description(m_value_items[v]);
         m_items[i].BackColor((m_selected_item_index==v) ? m_item_color_selected : m_item_color);
         m_items[i].Color((m_selected_item_index==v) ? m_item_text_color_selected : m_item_text_color);
         //--- Increase the counter
         v++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Highlights selected item                                         |
//+------------------------------------------------------------------+
void CListView::HighlightSelectedItem(void)
  {
//--- Leave, if the scrollbar is active
   if(m_scrollv.ScrollState())
      return;
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Iterate over the visible part of the list view
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- If inside the range of the list view
      if(v>=0 && v<m_items_total)
        {
         //--- Changing the background color and the text color
         m_items[i].BackColor((m_selected_item_index==v) ? m_item_color_selected : m_item_color);
         m_items[i].Color((m_selected_item_index==v) ? m_item_text_color_selected : m_item_text_color);
         //--- Increase the counter
         v++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CListView::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing indents in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
//--- Updating coordinates of graphical objects   
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
//---
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Storing coordinates in the fields of the objects
      m_items[r].X(x+m_items[r].XGap());
      m_items[r].Y(y+m_items[r].YGap());
      //--- Updating coordinates of graphical objects
      m_items[r].X_Distance(m_items[r].X());
      m_items[r].Y_Distance(m_items[r].Y());
     }
  }
//+------------------------------------------------------------------+
//| Show the list view                                               |
//+------------------------------------------------------------------+
void CListView::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- Show the scrollbar
   m_scrollv.Show();
//--- State of visibility
   CElement::IsVisible(true);
//--- Send a signal for zeroing priorities of the left mouse click
   if(CElement::IsDropdown())
      ::EventChartCustom(m_chart_id,ON_ZERO_PRIORITIES,m_id,0.0,"");
  }
//+------------------------------------------------------------------+
//| Hide the list view                                               |
//+------------------------------------------------------------------+
void CListView::Hide(void)
  {
   if(!m_wnd.IsMinimized())
      if(!CElement::IsDropdown())
         if(!CElement::IsVisible())
            return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- Hide the scrollbar
   m_scrollv.Hide();
//--- State of visibility
   CElement::IsVisible(false);
//--- Send a signal to restore the priorities of the left mouse click
   if(!m_wnd.IsMinimized())
      ::EventChartCustom(m_chart_id,ON_SET_PRIORITIES,0,0.0,"");
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CListView::Reset(void)
  {
//--- Leave, if this is a drop-down element
   if(CElement::IsDropdown())
      return;
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deletion                                                         |
//+------------------------------------------------------------------+
void CListView::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   for(int r=0; r<m_visible_items_total; r++)
      m_items[r].Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CListView::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_scrollv.SetZorders();
   for(int i=0; i<m_visible_items_total; i++)
      m_items[i].Z_Order(m_item_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CListView::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_scrollv.ResetZorders();
   for(int i=0; i<m_visible_items_total; i++)
      m_items[i].Z_Order(0);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the list view item                      |
//+------------------------------------------------------------------+
bool CListView::OnClickListItem(const string clicked_object)
  {
//--- Leave, if the form is blocked and identifiers do not match
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return(false);
//--- Leave, if the scrollbar is active
   if(m_scrollv.ScrollState())
      return(false);
//--- Leave, if the pressing was not on the menu item
   if(::StringFind(clicked_object,CElement::ProgramName()+"_listview_edit_",0)<0)
      return(false);
//--- Get the identifier and index from the object name
   int id=CElement::IdFromObjectName(clicked_object);
//--- Leave, if the identifier does not match
   if(id!=CElement::Id())
      return(false);
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Go over the visible part of the list view
   for(int i=0; i<m_visible_items_total; i++)
     {
      //--- If this list view item was selected
      if(m_items[i].Name()==clicked_object)
        {
         m_selected_item_index =v;
         m_selected_item_text  =m_value_items[v];
        }
      //--- If inside the range of the list view
      if(v>=0 && v<m_items_total)
         //--- Increase the counter
         v++;
     }
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElement::Id(),0,m_selected_item_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Fast forward of the list view                                    |
//+------------------------------------------------------------------+
void CListView::FastSwitching(void)
  {
//--- Leave, if there is no focus on the list view
   if(!CElement::MouseFocus())
      return;
//--- Return the counter to the initial value if the mouse button is released
   if(!m_mouse.LeftButtonState())
      m_timer_counter=SPIN_DELAY_MSC;
//--- If the mouse button is pressed down
   else
     {
      //--- Increase the counter by the set step
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Leave, if less than zero
      if(m_timer_counter<0)
         return;
      //--- If scrolling up
      if(m_scrollv.ScrollIncState())
         m_scrollv.OnClickScrollInc(m_scrollv.ScrollIncName());
      //--- If scrolling down
      else if(m_scrollv.ScrollDecState())
         m_scrollv.OnClickScrollDec(m_scrollv.ScrollDecName());
      //--- Moves the list
      ShiftList();
     }
  }
//+------------------------------------------------------------------+
