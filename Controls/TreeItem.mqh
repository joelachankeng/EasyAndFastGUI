//+------------------------------------------------------------------+
//|                                                     TreeItem.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a tree view item                              |
//+------------------------------------------------------------------+
class CTreeItem : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a tree view item
   CRectLabel        m_area;
   CBmpLabel         m_arrow;
   CBmpLabel         m_icon;
   CEdit             m_label;
   //--- Color of the background in different states
   color             m_item_back_color;
   color             m_item_back_color_hover;
   color             m_item_back_color_selected;
   //--- Indent for an arrow (sign of a list presence)
   int               m_arrow_x_offset;
   //--- Icons for the item arrow
   string            m_item_arrow_file_on;
   string            m_item_arrow_file_off;
   string            m_item_arrow_selected_file_on;
   string            m_item_arrow_selected_file_off;
   //--- Item icon
   string            m_icon_file;
   //--- Text label margins
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Color of the text in different item states
   color             m_item_text_color;
   color             m_item_text_color_hover;
   color             m_item_text_color_selected;
   //--- Priorities of the left mouse button press
   int               m_area_zorder;
   int               m_arrow_zorder;
   int               m_zorder;
   //--- Item type
   ENUM_TYPE_TREE_ITEM m_item_type;
   //--- Index of the item in the general list
   int               m_list_index;
   //--- Node level
   int               m_node_level;
   //--- Displayed text of the item
   string            m_item_text;
   //--- Item list state (open/minimized)
   bool              m_item_state;
   //---
public:
                     CTreeItem(void);
                    ~CTreeItem(void);
   //--- Methods for creating a tree view item
   bool              CreateTreeItem(const long chart_id,const int subwin,const int x,const int y,const ENUM_TYPE_TREE_ITEM type,
                                    const int list_index,const int node_level,const string item_text,const bool item_state);
   //---
private:
   bool              CreateArea(void);
   bool              CreateArrow(void);
   bool              CreateIcon(void);
   bool              CreateLabel(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) item background color
   void              WindowPointer(CWindow &object)                   { m_wnd=::GetPointer(object);               }
   void              ItemBackColor(const color clr)                   { m_item_back_color=clr;                    }
   void              ItemBackColorHover(const color clr)              { m_item_back_color_hover=clr;              }
   void              ItemBackColorSelected(const color clr)           { m_item_back_color_selected=clr;           }
   //--- (1) Set item icon, (2) set images for item arrow
   void              IconFile(const string file_path)                 { m_icon_file=file_path;                    }
   void              ItemArrowFileOn(const string file_path)          { m_item_arrow_file_on=file_path;           }
   void              ItemArrowFileOff(const string file_path)         { m_item_arrow_file_off=file_path;          }
   void              ItemArrowSelectedFileOn(const string file_path)  { m_item_arrow_selected_file_on=file_path;  }
   void              ItemArrowSelectedFileOff(const string file_path) { m_item_arrow_selected_file_off=file_path; }
   //--- (1) Returns the item text, (2) sets indents for the text label
   string            LabelText(void)                            const { return(m_label.Description());            }
   void              LabelXGap(const int x_gap)                       { m_label_x_gap=x_gap;                      }
   void              LabelYGap(const int y_gap)                       { m_label_y_gap=y_gap;                      }
   //--- Color of the text in different states
   void              ItemTextColor(const color clr)                   { m_item_text_color=clr;                    }
   void              ItemTextColorHover(const color clr)              { m_item_text_color_hover=clr;              }
   void              ItemTextColorSelected(const color clr)           { m_item_text_color_selected=clr;           }
   //--- Update the coordinates and width
   void              UpdateX(const int x);
   void              UpdateY(const int y);
   void              UpdateWidth(const int width);
   //--- Change the color of the menu item relative to the specified state
   void              HighlightItemState(const bool state);
   //--- Change the color on mouseover
   void              ChangeObjectsColor(void);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void) {}
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
   //--- Reset the color
   virtual void      ResetColors(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTreeItem::CTreeItem(void) : m_node_level(0),
                             m_arrow_x_offset(5),
                             m_item_type(TI_SIMPLE),
                             m_item_state(false),
                             m_label_x_gap(16),
                             m_label_y_gap(2),
                             m_item_back_color(clrWhite),
                             m_item_back_color_hover(C'240,240,240'),
                             m_item_back_color_selected(C'51,153,255'),
                             m_item_text_color(clrBlack),
                             m_item_text_color_hover(clrBlack),
                             m_item_text_color_selected(clrWhite),
                             m_icon_file(""),
                             m_item_arrow_file_on(""),
                             m_item_arrow_file_off(""),
                             m_item_arrow_selected_file_on(""),
                             m_item_arrow_selected_file_off("")
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_area_zorder  =1;
   m_arrow_zorder =2;
   m_zorder       =0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTreeItem::~CTreeItem(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CTreeItem::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- Checking the focus over element
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create a tree view item                                          |
//+------------------------------------------------------------------+
bool CTreeItem::CreateTreeItem(const long chart_id,const int subwin,const int x,const int y,const ENUM_TYPE_TREE_ITEM type,
                               const int list_index,const int node_level,const string item_text,const bool item_state)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id             =m_wnd.LastId()+1;
   m_chart_id       =chart_id;
   m_subwin         =subwin;
   m_x              =x;
   m_y              =y;
   m_item_type      =type;
   m_list_index     =list_index;
   m_node_level     =node_level;
   m_item_text      =item_text;
   m_item_state     =item_state;
   m_arrow_x_offset =(m_node_level>0)? (12*m_node_level)+5 : 5;
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating a menu item
   if(!CreateArea())
      return(false);
   if(!CreateArrow())
      return(false);
   if(!CreateIcon())
      return(false);
   if(!CreateLabel())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the area of the tree view item                            |
//+------------------------------------------------------------------+
bool CTreeItem::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_"+(string)CElement::Index()+"_treeitem_area_"+(string)m_list_index+"__"+(string)CElement::Id();
//--- Set the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   m_area.BackColor(m_item_back_color);
   m_area.Color(m_item_back_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Margins from the edge
   m_area.XGap(CElement::X()-m_wnd.X());
   m_area.YGap(CElement::Y()-m_wnd.Y());
//--- Size
   m_area.XSize(CElement::XSize());
   m_area.YSize(CElement::YSize());
   CElement::XSize(CElement::XSize());
   CElement::YSize(CElement::YSize());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create an arrow (sign of a drop-down list)                       |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_rotate_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_rotate_white.bmp"
//---
bool CTreeItem::CreateArrow(void)
  {
//--- Calculate the coordinates
   int x =CElement::X()+m_arrow_x_offset;
   int y =CElement::Y()+2;
//--- Store the coordinates to calculate the next objects of the control in the creation queue
   m_arrow.X(x);
   m_arrow.Y(y);
//--- Leave, if the item does not have a drop-down list
   if(m_item_type!=TI_HAS_ITEMS)
      return(true);
//--- Forming the object name
   string name=CElement::ProgramName()+"_"+(string)CElement::Index()+"_treeitem_arrow_"+(string)m_list_index+"__"+(string)CElement::Id();
//--- Set the default icons
   if(m_item_arrow_file_on=="")
      m_item_arrow_file_on="Images\\EasyAndFastGUI\\Controls\\RArrow_rotate_black.bmp";
   if(m_item_arrow_file_off=="")
      m_item_arrow_file_off="Images\\EasyAndFastGUI\\Controls\\RArrow_black.bmp";
   if(m_item_arrow_selected_file_on=="")
      m_item_arrow_selected_file_on="Images\\EasyAndFastGUI\\Controls\\RArrow_rotate_white.bmp";
   if(m_item_arrow_selected_file_off=="")
      m_item_arrow_selected_file_off="Images\\EasyAndFastGUI\\Controls\\RArrow_white.bmp";
//--- Set the object
   if(!m_arrow.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_arrow.BmpFileOn("::"+m_item_arrow_file_on);
   m_arrow.BmpFileOff("::"+m_item_arrow_file_off);
   m_arrow.State(m_item_state);
   m_arrow.Corner(m_corner);
   m_arrow.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_arrow.Selectable(false);
   m_arrow.Z_Order(m_arrow_zorder);
   m_arrow.Tooltip("\n");
//--- Margins from the edge
   m_arrow.XGap(x-m_wnd.X());
   m_arrow.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_arrow);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the item icon                                             |
//+------------------------------------------------------------------+
bool CTreeItem::CreateIcon(void)
  {
//--- Calculate the coordinates
   int x =m_arrow.X()+17;
   int y =CElement::Y()+2;
//--- Store coordinates
   m_icon.X(x);
   m_icon.Y(y);
//--- Leave, if the icon is not needed
   if(m_icon_file=="")
      return(true);
//--- Forming the object name
   string name=CElement::ProgramName()+"_"+(string)CElement::Index()+"_treeitem_icon_"+(string)m_list_index+"__"+(string)CElement::Id();
//--- Set the object
   if(!m_icon.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_icon.BmpFileOn("::"+m_icon_file);
   m_icon.BmpFileOff("::"+m_icon_file);
   m_icon.State(true);
   m_icon.Corner(m_corner);
   m_icon.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_icon.Selectable(false);
   m_icon.Z_Order(m_zorder);
   m_icon.Tooltip("\n");
//--- Margins from the edge
   m_icon.XGap(x-m_wnd.X());
   m_icon.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_icon);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the text label of an item                                |
//+------------------------------------------------------------------+
bool CTreeItem::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_"+(string)CElement::Index()+"_treeitem_lable_"+(string)m_list_index+"__"+(string)CElement::Id();
//--- Calculate the coordinates and width
   int x=(m_icon_file=="")? m_icon.X() : m_icon.X()+m_label_x_gap;
   int y=CElement::Y()+m_label_y_gap;
   int w=CElement::X2()-x-1;
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y,w,15))
      return(false);
//--- Setting the properties
   m_label.Description(m_item_text);
   m_label.TextAlign(ALIGN_LEFT);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(m_item_text_color);
   m_label.BackColor(m_item_back_color);
   m_label.BorderColor(m_item_back_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
   m_label.ReadOnly(true);
   m_label.Tooltip("\n");
//--- Coordinates
   m_label.X(x);
   m_label.Y(y);
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Update the X coordinate                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateX(const int x)
  {
//--- Update the common coordinates and indents form the edge point
   CElement::X(x);
   CElement::XGap(CElement::X()-m_wnd.X());
//--- Coordinates and indent of the background
   m_area.X_Distance(CElement::X());
   m_area.XGap(CElement::X()-m_wnd.X());
//--- Coordinates and indent of the arrow
   int l_x=CElement::X()+m_arrow_x_offset;
   m_arrow.X(l_x);
   m_arrow.X_Distance(l_x);
   m_arrow.XGap(l_x-m_wnd.X());
//--- Coordinates and indent of the icon
   l_x=m_arrow.X()+17;
   m_icon.X(l_x);
   m_icon.X_Distance(l_x);
   m_icon.XGap(l_x-m_wnd.X());
//--- Coordinates and indent of the text label
   l_x=(m_icon_file=="")? m_icon.X() : m_icon.X()+m_label_x_gap;
   m_label.X(l_x);
   m_label.X_Distance(l_x);
   m_label.XGap(l_x-m_wnd.X());
  }
//+------------------------------------------------------------------+
//| Update the Y coordinate                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateY(const int y)
  {
//--- Update the common coordinates and indents form the edge point
   CElement::Y(y);
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Coordinates and indent of the background
   m_area.Y_Distance(CElement::Y());
   m_area.YGap(CElement::Y()-m_wnd.Y());
//--- Coordinates and indent of the arrow
   int l_y=CElement::Y()+2;
   m_arrow.Y(l_y);
   m_arrow.Y_Distance(l_y);
   m_arrow.YGap(l_y-m_wnd.Y());
//--- Coordinates and indent of the icon
   l_y=CElement::Y()+2;
   m_icon.Y(l_y);
   m_icon.Y_Distance(l_y);
   m_icon.YGap(l_y-m_wnd.Y());
//--- Coordinates and indent of the text label
   l_y=CElement::Y()+m_label_y_gap;
   m_label.Y(l_y);
   m_label.Y_Distance(l_y);
   m_label.YGap(l_y-m_wnd.Y());
  }
//+------------------------------------------------------------------+
//| Update width                                                     |
//+------------------------------------------------------------------+
void CTreeItem::UpdateWidth(const int width)
  {
//--- Background width
   CElement::XSize(width);
   m_area.XSize(width);
   m_area.X_Size(width);
//--- Text label width
   int w=CElement::X2()-m_label.X()-1;
   m_label.XSize(w);
   m_label.X_Size(w);
  }
//+------------------------------------------------------------------+
//| Change the color of the menu item relative to specified state    |
//+------------------------------------------------------------------+
void CTreeItem::HighlightItemState(const bool state)
  {
   m_area.BackColor((state)? m_item_back_color_selected : m_item_back_color);
   m_label.BackColor((state)? m_item_back_color_selected : m_item_back_color);
   m_label.BorderColor((state)? m_item_back_color_selected : m_item_back_color);
   m_label.Color((state)? m_item_text_color_selected : m_item_text_color);
   m_arrow.BmpFileOn((state)? "::"+m_item_arrow_selected_file_on : "::"+m_item_arrow_file_on);
   m_arrow.BmpFileOff((state)? "::"+m_item_arrow_selected_file_off : "::"+m_item_arrow_file_off);
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CTreeItem::ChangeObjectsColor(void)
  {
   if(CElement::MouseFocus())
     {
      m_area.BackColor(m_item_back_color_hover);
      m_label.BackColor(m_item_back_color_hover);
      m_label.BorderColor(m_item_back_color_hover);
      m_label.Color(m_item_text_color_hover);
     }
   else
     {
      m_area.BackColor(m_item_back_color);
      m_label.BackColor(m_item_back_color);
      m_label.BorderColor(m_item_back_color);
      m_label.Color(m_item_text_color);
     }
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CTreeItem::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing indents in the element fields
   CElement::X(x+CElement::XGap());
   CElement::Y(y+CElement::YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
   m_arrow.X(x+m_arrow.XGap());
   m_arrow.Y(y+m_arrow.YGap());
   m_icon.X(x+m_icon.XGap());
   m_icon.Y(y+m_icon.YGap());
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_arrow.X_Distance(m_arrow.X());
   m_arrow.Y_Distance(m_arrow.Y());
   m_icon.X_Distance(m_icon.X());
   m_icon.Y_Distance(m_icon.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
  }
//+------------------------------------------------------------------+
//| Shows a menu item                                                |
//+------------------------------------------------------------------+
void CTreeItem::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   m_area.Timeframes(OBJ_ALL_PERIODS);
   m_arrow.Timeframes(OBJ_ALL_PERIODS);
   m_icon.Timeframes(OBJ_ALL_PERIODS);
   m_label.Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CTreeItem::Hide(void)
  {
//--- Leave, if the element is already hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   m_area.Timeframes(OBJ_NO_PERIODS);
   m_arrow.Timeframes(OBJ_NO_PERIODS);
   m_icon.Timeframes(OBJ_NO_PERIODS);
   m_label.Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CTreeItem::Reset(void)
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
void CTreeItem::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_arrow.Delete();
   m_icon.Delete();
   m_label.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CTreeItem::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_arrow.Z_Order(m_arrow_zorder);
   m_icon.Z_Order(m_zorder);
   m_label.Z_Order(m_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CTreeItem::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_arrow.Z_Order(0);
   m_icon.Z_Order(0);
   m_label.Z_Order(0);
  }
//+------------------------------------------------------------------+
//| Reset color                                                      |
//+------------------------------------------------------------------+
void CTreeItem::ResetColors(void)
  {
   m_area.BackColor(m_item_back_color);
   m_label.BackColor(m_item_back_color);
   m_label.BorderColor(m_item_back_color);
//--- Zero the focus
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
