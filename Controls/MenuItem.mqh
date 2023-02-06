//+------------------------------------------------------------------+
//|                                                     MenuItem.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a menu item                                   |
//+------------------------------------------------------------------+
class CMenuItem : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a menu item
   CRectLabel        m_area;
   CBmpLabel         m_icon;
   CLabel            m_label;
   CBmpLabel         m_arrow;
   //--- Pointer to the previous node
   CMenuItem        *m_prev_node;
   //--- Menu item type
   ENUM_TYPE_MENU_ITEM m_type_menu_item;
   //--- Background properties
   int               m_area_zorder;
   color             m_area_border_color;
   color             m_area_color;
   color             m_area_color_hover;
   color             m_area_color_hover_off;
   //--- Label properties
   string            m_icon_file_on;
   string            m_icon_file_off;
   //--- Text label properties
   string            m_label_text;
   int               m_label_x_gap;
   int               m_label_y_gap;
   color             m_label_color;
   color             m_label_color_off;
   color             m_label_color_hover;
   //--- Properties of the indication of the context menu
   bool              m_show_right_arrow;
   string            m_right_arrow_file_on;
   string            m_right_arrow_file_off;
   //--- General priority for clicking
   int               m_zorder;
   //--- Available/blocked
   bool              m_item_state;
   //--- Checkbox state
   bool              m_checkbox_state;
   //--- State of the radio button and its identifier
   bool              m_radiobutton_state;
   int               m_radiobutton_id;
   //--- State of the context menu
   bool              m_context_menu_state;
   //---
   bool              m_preventing_reopening;
   //---
public:
                     CMenuItem(void);
                    ~CMenuItem(void);
   //--- Methods for creating a menu item
   bool              CreateMenuItem(const long chart_id,const int subwin,const int index_number,const string label_text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateIcon(void);
   bool              CreateLabel(void);
   bool              CreateArrow(void);
   //--- Clicking on the menu item
   bool              OnClickMenuItem(const string clicked_object);
   //---
public:
   //--- (1) Stores the form pointer
   //    (2) Getting and (3) storing the pointer to the previous node
   void              WindowPointer(CWindow &object)                 { m_wnd=::GetPointer(object);            }
   CMenuItem        *PrevNodePointer(void)                    const { return(m_prev_node);                   }
   void              PrevNodePointer(CMenuItem &object)             { m_prev_node=::GetPointer(object);      }
   //--- (1) Setting and getting the type, (2) index number
   void              TypeMenuItem(const ENUM_TYPE_MENU_ITEM type)   { m_type_menu_item=type;                 }
   ENUM_TYPE_MENU_ITEM TypeMenuItem(void)                     const { return(m_type_menu_item);              }
   //--- Background methods
   void              AreaBackColor(const color clr)                 { m_area_color=clr;                      }
   void              AreaBackColorHover(const color clr)            { m_area_color_hover=clr;                }
   void              AreaBackColorHoverOff(const color clr)         { m_area_color_hover_off=clr;            }
   void              AreaBorderColor(const color clr)               { m_area_border_color=clr;               }
   //--- Label methods
   void              IconFileOn(const string file_path)             { m_icon_file_on=file_path;              }
   void              IconFileOff(const string file_path)            { m_icon_file_off=file_path;             }
   //--- Text label methods
   string            LabelText(void)                          const { return(m_label.Description());         }
   void              LabelXGap(const int x_gap)                     { m_label_x_gap=x_gap;                   }
   void              LabelYGap(const int y_gap)                     { m_label_y_gap=y_gap;                   }
   void              LabelColor(const color clr)                    { m_label_color=clr;                     }
   void              LabelColorOff(const color clr)                 { m_label_color_off=clr;                 }
   void              LabelColorHover(const color clr)               { m_label_color_hover=clr;               }
   //--- Methods to indicate the presence of a context menu
   void              ShowRightArrow(const bool flag)                { m_show_right_arrow=flag;               }
   void              RightArrowFileOn(const string file_path)       { m_right_arrow_file_on=file_path;       }
   void              RightArrowFileOff(const string file_path)      { m_right_arrow_file_off=file_path;      }
   //--- Common (1) state of the item and (2) the checkbox item
   void              ItemState(const bool state);
   bool              ItemState(void)                          const { return(m_item_state);                  }
   void              CheckBoxState(const bool flag)                 { m_checkbox_state=flag;                 }
   bool              CheckBoxState(void)                      const { return(m_checkbox_state);              }
   //--- Radio item identifier
   void              RadioButtonID(const int id)                    { m_radiobutton_id=id;                   }
   int               RadioButtonID(void)                      const { return(m_radiobutton_id);              }
   //--- State of the radio item
   void              RadioButtonState(const bool flag)              { m_radiobutton_state=flag;              }
   bool              RadioButtonState(void)                   const { return(m_radiobutton_state);           }
   //--- State of the context menu attached to this item
   bool              ContextMenuState(void)                   const { return(m_context_menu_state);          }
   void              ContextMenuState(const bool flag)              { m_context_menu_state=flag;             }
   //--- Prevention of re-opening
   bool              PreventingReopeningState(void)           const { return(m_preventing_reopening);        }
   void              PreventingReopeningState(const bool flag)      { m_preventing_reopening=flag;           }

   //--- Change the color of the menu item relative to the specified state
   void              HighlightItemState(const bool state);
   //--- Changing the color of the element objects
   void              ChangeObjectsColor(void);
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
   //--- (1) Setting, (2) resetting of priorities for left clicking on mouse
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Reset the color
   virtual void      ResetColors(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMenuItem::CMenuItem(void) : m_type_menu_item(MI_SIMPLE),
                             m_context_menu_state(false),
                             m_item_state(true),
                             m_checkbox_state(true),
                             m_radiobutton_id(0),
                             m_radiobutton_state(false),
                             m_preventing_reopening(false),
                             m_icon_file_on(""),
                             m_icon_file_off(""),
                             m_show_right_arrow(true),
                             m_right_arrow_file_on(""),
                             m_right_arrow_file_off(""),
                             m_area_color(clrNONE),
                             m_area_color_hover(C'51,153,255'),
                             m_area_color_hover_off(C'240,240,240'),
                             m_area_border_color(clrNONE),
                             m_label_x_gap(32),
                             m_label_y_gap(5),
                             m_label_color(clrBlack),
                             m_label_color_off(clrGray),
                             m_label_color_hover(clrWhite)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set a strict sequence of priorities
   m_area_zorder =2;
   m_zorder      =0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMenuItem::~CMenuItem(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CMenuItem::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling of the cursor movement event  
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the element is hidden
      if(!CElement::IsVisible())
         return;
      if(::CheckPointer(m_mouse)==POINTER_INVALID)
        return;
      //--- Leave, if numbers of subwindows do not match
      if(CElement::m_subwin!=m_mouse.SubWindowNumber())
         return;
      //--- Define the focus
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickMenuItem(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CMenuItem::OnEventTimer(void)
  {
//--- If the window is available
   if(!m_wnd.IsLocked())
     {
      //--- If the status of a disabled context menu
      if(!m_context_menu_state)
         //--- Changing the color of the form objects
         ChangeObjectsColor();
     }
  }
//+------------------------------------------------------------------+
//| Creates the menu item element                                    |
//+------------------------------------------------------------------+
bool CMenuItem::CreateMenuItem(const long chart_id,const int subwin,const int index_number,const string label_text,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- If there is no pointer to the previous node, then
//    an independent menu item is implied, that is the one that is not a part of a context menu
   if(::CheckPointer(m_prev_node)==POINTER_INVALID)
     {
      //--- Leave, if the set type does not match
      if(m_type_menu_item!=MI_SIMPLE && m_type_menu_item!=MI_HAS_CONTEXT_MENU)
        {
         ::Print(__FUNCTION__," > The type of the independent menu item can be only MI_SIMPLE or MI_HAS_CONTEXT_MENU,",
                 "that is only with a context menu.\n",
                 __FUNCTION__," > The type of the menu item can be set using the CMenuItem::TypeMenuItem()) method");
         return(false);
        }
     }
//--- Initializing variables
   m_id         =m_wnd.LastId()+1;
   m_index      =index_number;
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_label_text =label_text;
   m_x          =x;
   m_y          =y;
   m_area_color =(m_area_color!=clrNONE)? m_area_color : m_wnd.WindowBgColor();
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating a menu item
   if(!CreateArea())
      return(false);
   if(!CreateIcon())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateArrow())
      return(false);
//--- If the form is minimized, hide the element after creation
   if(m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates menu item area                                           |
//+------------------------------------------------------------------+
bool CMenuItem::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_menuitem_area_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Set the background of the menu item
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_border_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Margins from the edge
   m_area.XGap(m_x-m_wnd.X());
   m_area.YGap(m_y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates an item label                                            |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_gray.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_white.bmp"
//---
bool CMenuItem::CreateIcon(void)
  {
//--- If this is a simple item or an item containing a context menu
   if(m_type_menu_item==MI_SIMPLE || m_type_menu_item==MI_HAS_CONTEXT_MENU)
     {
      //--- If the label is not required (icon is not defined), leave
      if(m_icon_file_on=="" || m_icon_file_off=="")
         return(true);
     }
//--- If this is a checkbox
   else if(m_type_menu_item==MI_CHECKBOX)
     {
      //--- If the icon is not defined, set the default one
      if(m_icon_file_on=="")
         m_icon_file_on="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_white.bmp";
      if(m_icon_file_off=="")
         m_icon_file_off="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_gray.bmp";
     }
//--- If this is a radio item     
   else if(m_type_menu_item==MI_RADIOBUTTON)
     {
      //--- If the icon is not defined, set the default one
      if(m_icon_file_on=="")
         m_icon_file_on="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_white.bmp";
      if(m_icon_file_off=="")
         m_icon_file_off="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_gray.bmp";
     }
//--- Forming the object name
   string name=CElement::ProgramName()+"_menuitem_icon_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Object coordinates
   int x =m_x+7;
   int y =m_y+4;
//--- Set up the icon
   if(!m_icon.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_icon.BmpFileOn("::"+m_icon_file_on);
   m_icon.BmpFileOff("::"+m_icon_file_off);
   m_icon.State(m_item_state);
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
//| Creates the text label of a menu item                            |
//+------------------------------------------------------------------+
bool CMenuItem::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_menuitem_lable_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Object coordinates
   int x =m_x+m_label_x_gap;
   int y =m_y+m_label_y_gap;
//--- The color of the text depends on the current state (available/blocked)
   color label_color=(m_item_state)? m_label_color : m_label_color_off;
//--- Set the text label
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_label.Description(m_label_text);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
   m_label.Tooltip("\n");
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates an arrow (sign of a drop-down context menu)              |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_white.bmp"
//---
bool CMenuItem::CreateArrow(void)
  {
//--- Leave, if the item does not have a drop-down menu or the arrow is not required
   if(m_type_menu_item!=MI_HAS_CONTEXT_MENU || !m_show_right_arrow)
      return(true);
//--- Forming the object name
   string name=CElement::ProgramName()+"_menuitem_arrow_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Object coordinates
   int x =m_x+CElement::XSize()-16;
   int y =m_y+4;
//--- If the icon for the arrow is not specified, then set the default one
   if(m_right_arrow_file_on=="")
      m_right_arrow_file_on="Images\\EasyAndFastGUI\\Controls\\RArrow_white.bmp";
   if(m_right_arrow_file_off=="")
      m_right_arrow_file_off="Images\\EasyAndFastGUI\\Controls\\RArrow.bmp";
//--- Set the arrow
   if(!m_arrow.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_arrow.BmpFileOn("::"+m_right_arrow_file_on);
   m_arrow.BmpFileOff("::"+m_right_arrow_file_off);
   m_arrow.State(false);
   m_arrow.Corner(m_corner);
   m_arrow.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_arrow.Selectable(false);
   m_arrow.Z_Order(m_zorder);
   m_arrow.Tooltip("\n");
//--- Margins from the edge
   m_arrow.XGap(x-m_wnd.X());
   m_arrow.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_arrow);
   return(true);
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CMenuItem::ChangeObjectsColor(void)
  {
//--- Leave, if this item has a context menu and it is enabled
   if(m_type_menu_item==MI_HAS_CONTEXT_MENU && m_context_menu_state)
      return;
//--- Code block for simple items and items containing a context menu
   if(m_type_menu_item==MI_HAS_CONTEXT_MENU || m_type_menu_item==MI_SIMPLE)
     {
      //--- If there is focus
      if(CElement::MouseFocus())
        {
         //Print(__FUNCSIG__," >>> index: ",m_index,"; text: ",m_label_text);
         m_icon.State(m_item_state);
         m_area.BackColor((m_item_state)? m_area_color_hover : m_area_color_hover_off);
         m_label.Color((m_item_state)? m_label_color_hover : m_label_color_off);
         if(m_item_state)
            m_arrow.State(true);
        }
      //--- If there is no focus
      else
        {
         m_arrow.State(false);
         m_area.BackColor(m_area_color);
         m_label.Color((m_item_state)? m_label_color : m_label_color_off);
        }
     }
//--- Code block for checkbox items and radio items
   else if(m_type_menu_item==MI_CHECKBOX || m_type_menu_item==MI_RADIOBUTTON)
     {
      m_icon.State(CElement::MouseFocus());
      m_area.BackColor((CElement::MouseFocus())? m_area_color_hover : m_area_color);
      m_label.Color((CElement::MouseFocus())? m_label_color_hover : m_label_color);
     }
  }
//+------------------------------------------------------------------+
//| Changing the menu item state                                     |
//+------------------------------------------------------------------+
void CMenuItem::ItemState(const bool state)
  {
   m_item_state=state;
   m_icon.State(state);
   m_label.Color((state)? m_label_color : m_label_color_off);
  }
//+------------------------------------------------------------------+
//| Change the color of the menu item relative to specified state    |
//+------------------------------------------------------------------+
void CMenuItem::HighlightItemState(const bool state)
  {
   m_area.BackColor((state)? m_area_color_hover : m_area_color);
   m_label.Color((state)? m_label_color_hover : m_label_color);
   m_arrow.State(state);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CMenuItem::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing coordinates in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
   m_icon.X(x+m_icon.XGap());
   m_icon.Y(y+m_icon.YGap());
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
   m_arrow.X(x+m_arrow.XGap());
   m_arrow.Y(y+m_arrow.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_icon.X_Distance(m_icon.X());
   m_icon.Y_Distance(m_icon.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
   m_arrow.X_Distance(m_arrow.X());
   m_arrow.Y_Distance(m_arrow.Y());
  }
//+------------------------------------------------------------------+
//| Makes a menu item visible                                        |
//+------------------------------------------------------------------+
void CMenuItem::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Disable highlighting the selected item
   HighlightItemState(false);
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- If this is a checkbox, then considering its state
   if(m_type_menu_item==MI_CHECKBOX)
      m_icon.Timeframes((m_checkbox_state)? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
//--- If this is a radio item, then considering its state
   else if(m_type_menu_item==MI_RADIOBUTTON)
      m_icon.Timeframes((m_radiobutton_state)? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
//--- Zeroing variables
   CElement::IsVisible(true);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CMenuItem::Hide(void)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- Zeroing variables
   m_context_menu_state=false;
   CElement::IsVisible(false);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CMenuItem::Reset(void)
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
void CMenuItem::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_icon.Delete();
   m_label.Delete();
   m_arrow.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   m_context_menu_state=false;
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CMenuItem::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_icon.Z_Order(m_zorder);
   m_label.Z_Order(m_zorder);
   m_arrow.Z_Order(m_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CMenuItem::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_icon.Z_Order(0);
   m_label.Z_Order(0);
   m_arrow.Z_Order(0);
  }
//+------------------------------------------------------------------+
//| Reset the item color                                             |
//+------------------------------------------------------------------+
void CMenuItem::ResetColors(void)
  {
   m_area.BackColor(m_area_color);
   m_label.Color(m_label_color);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Handling clicking on the menu item                               |
//+------------------------------------------------------------------+
bool CMenuItem::OnClickMenuItem(const string clicked_object)
  {
//--- Check for the object name
   if(m_area.Name()!=clicked_object)
      return(false);
//--- Leave, if the item has not been activated
   if(!m_item_state)
      return(false);
//--- If this item contains a context menu
   if(m_type_menu_item==MI_HAS_CONTEXT_MENU)
     {
      //--- If the drop-down menu of this item has not been activated
      if(!m_context_menu_state)
        {
         if(m_preventing_reopening)
           return(true);
         //--- Assign the status of an enabled context menu
         m_context_menu_state=true;
        }
      else
        {
         //--- Assign the status of a disabled context menu
         m_context_menu_state=false;
         //--- Send a signal for closing context menus, which are below this item
         ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElement::Id(),0,"");
        }
      return(true);
     }
//--- If this item does not contain a context menu, but is a part of a context menu itself
   else
     {
      //--- Message prefix with the program name
      string message=CElement::ProgramName();
      //--- If this is a checkbox, change its state
      if(m_type_menu_item==MI_CHECKBOX)
        {
         m_checkbox_state=(m_checkbox_state)? false : true;
         m_icon.Timeframes((m_checkbox_state)? OBJ_NO_PERIODS : OBJ_ALL_PERIODS);
         //--- Add to the message that this is a checkbox
         message+="_checkbox";
        }
      //--- If this is a radio item, change its state
      else if(m_type_menu_item==MI_RADIOBUTTON)
        {
         m_radiobutton_state=(m_radiobutton_state)? false : true;
         m_icon.Timeframes((m_radiobutton_state)? OBJ_NO_PERIODS : OBJ_ALL_PERIODS);
         //--- Add to the message that this is a radio item
         message+="_radioitem_"+(string)m_radiobutton_id;
        }
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CLICK_MENU_ITEM,CElement::Id(),CElement::Index(),message);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
