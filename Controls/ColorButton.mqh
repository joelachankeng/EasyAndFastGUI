//+------------------------------------------------------------------+
//|                                                  ColorButton.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating buttons to call the color picker              |
//+------------------------------------------------------------------+
class CColorButton : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating the element
   CRectLabel        m_area;
   CLabel            m_label;
   CButton           m_button;
   CRectLabel        m_button_icon;
   CLabel            m_button_label;
   //--- Background color
   color             m_area_color;
   //--- Description text
   string            m_label_text;
   //--- Description indents
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Color of the description in different states
   color             m_label_color;
   color             m_label_color_off;
   color             m_label_color_hover;
   color             m_label_color_array[];
   //--- Button sizes
   int               m_button_x_size;
   int               m_button_y_size;
   //--- Color of the button in different states
   color             m_back_color;
   color             m_back_color_off;
   color             m_back_color_hover;
   color             m_back_color_pressed;
   color             m_back_color_array[];
   //--- Frame color
   color             m_border_color;
   color             m_border_color_off;
   color             m_border_color_hover;
   color             m_border_color_array[];
   //--- Color of the button text in different states
   color             m_button_label_color;
   color             m_button_label_color_off;
   color             m_button_label_color_hover;
   color             m_button_label_color_pressed;
   color             m_button_label_color_array[];
   //--- Available/blocked
   bool              m_button_state;
   //--- Selected color
   color             m_current_color;
   //--- Priorities of the left mouse button press
   int               m_button_zorder;
   int               m_zorder;
   //---
public:
                     CColorButton(void);
                    ~CColorButton(void);
   //--- Methods for creating the control
   bool              CreateColorButton(const long chart_id,const int subwin,const string button_text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateLabel(void);
   bool              CreateButton(void);
   bool              CreateButtonIcon(void);
   bool              CreateButtonLabel(void);
   //---
public:
   //--- Stores (1) the form pointer
   void              WindowPointer(CWindow &object)           { m_wnd=::GetPointer(object);    }
   bool              ButtonState(void) const            const { return(m_button_state);        }
   void              ButtonState(const bool state);
   //--- Color (1) of the control background, (2) button sizes
   void              AreaColor(const color clr)               { m_area_color=clr;              }
   void              ButtonXSize(const int x_size)            { m_button_x_size=x_size;        }
   void              ButtonYSize(const int y_size)            { m_button_y_size=y_size;        }
   //--- (1) Text of the control description, (2) description indents
   string            LabelText(void)                    const { return(m_label.Description()); }
   void              LabelXGap(const int x_gap)               { m_label_x_gap=x_gap;           }
   void              LabelYGap(const int y_gap)               { m_label_y_gap=y_gap;           }
   //--- Color of the description text in different states
   void              LabelColor(const color clr)              { m_label_color=clr;             }
   void              LabelColorOff(const color clr)           { m_label_color_off=clr;         }
   void              LabelColorHover(const color clr)         { m_label_color_hover=clr;       }
   //--- Color of the button background in different states
   void              BackColor(const color clr)               { m_back_color=clr;              }
   void              BackColorHover(const color clr)          { m_back_color_hover=clr;        }
   void              BackColorPressed(const color clr)        { m_back_color_pressed=clr;      }
   //--- (1) Colors of the button frame in different states, (2) get/set the current color of the parameter
   void              BorderColor(const color clr)             { m_border_color=clr;            }
   void              BorderColorOff(const color clr)          { m_border_color_off=clr;        }
   color             CurrentColor(void)                 const { return(m_current_color);       }
   void              CurrentColor(const color clr);
   //--- Changing the color of the element
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
   //--- (1) Set, (2) reset priorities of the left mouse button press
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Reset the color
   virtual void      ResetColors(void);
   //---
private:
   //--- Handling the pressing of a button
   bool              OnClickButton(const string clicked_object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CColorButton::CColorButton(void) : m_button_state(true),
                                   m_current_color(clrGold),
                                   m_area_color(clrNONE),
                                   m_label_x_gap(20),
                                   m_label_y_gap(3),
                                   m_button_y_size(18),
                                   m_label_color(clrBlack),
                                   m_label_color_off(clrSilver),
                                   m_label_color_hover(C'85,170,255'),
                                   m_back_color(C'220,220,220'),
                                   m_back_color_off(C'230,230,230'),
                                   m_back_color_hover(C'193,218,255'),
                                   m_back_color_pressed(C'153,178,215'),
                                   m_border_color(clrSilver),
                                   m_border_color_off(clrSilver),
                                   m_border_color_hover(C'85,170,255'),
                                   m_button_label_color(clrBlack),
                                   m_button_label_color_off(clrDarkGray),
                                   m_button_label_color_hover(clrBlack),
                                   m_button_label_color_pressed(clrBlack)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_button_zorder =1;
   m_zorder        =0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CColorButton::~CColorButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CColorButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      m_button.MouseFocus(m_mouse.X()>m_button.X() && m_mouse.X()<m_button.X2() && m_mouse.Y()>m_button.Y() && m_mouse.Y()<m_button.Y2());
      //--- Leave, if the form is blocked
      if(m_wnd.IsLocked())
         return;
      //--- Leave, if the left mouse button is released
      if(!m_mouse.LeftButtonState())
         return;
      //--- Leave, if the button is blocked
      if(!m_button_state)
         return;
      //--- If there is no focus
      if(!CElement::MouseFocus())
        {
         m_button.BackColor(m_back_color);
         return;
        }
      //--- If there is focus
      else
        {
         m_label.Color(m_label_color_hover);
         //--- Set the color considering the focus
         if(m_button.MouseFocus())
            m_button.BackColor(m_back_color_pressed);
         else
            m_button.BackColor(m_back_color_hover);
         //---
         return;
        }
      //---
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickButton(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CColorButton::OnEventTimer(void)
  {
//--- If the element is a drop-down
   if(CElement::IsDropdown())
      ChangeObjectsColor();
   else
     {
      //--- If the form and the button are not blocked
      if(!m_wnd.IsLocked() && m_button_state)
         ChangeObjectsColor();
     }
  }
//+------------------------------------------------------------------+
//| Create Button object                                             |
//+------------------------------------------------------------------+
bool CColorButton::CreateColorButton(const long chart_id,const int subwin,const string button_text,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id         =m_wnd.LastId()+1;
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_x          =x;
   m_y          =y;
   m_label_text =button_text;
   m_area_color =(m_area_color!=clrNONE)? m_area_color : m_wnd.WindowBgColor();
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating a button
   if(!CreateArea())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateButton())
      return(false);
   if(!CreateButtonIcon())
      return(false);
   if(!CreateButtonLabel())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create area                                                      |
//+------------------------------------------------------------------+
bool CColorButton::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_color_button_area_"+(string)CElement::Id();
//--- Creating the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_zorder);
   m_area.Tooltip("\n");
//--- Margins from the edge
   m_area.XGap(CElement::m_x-m_wnd.X());
   m_area.YGap(CElement::m_y-m_wnd.Y());
//--- Store the sizes (in the group)
   CElement::XSize(m_x_size);
   CElement::YSize(m_y_size);
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a label                                                   |
//+------------------------------------------------------------------+
bool CColorButton::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_color_button_lable_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y()+2;
//--- Text color according to the state
   color label_color=(m_button_state)? m_label_color : m_label_color_off;
//--- Creating the object
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
//--- Initializing gradient array
   CElement::InitColorArray(label_color,m_label_color_hover,m_label_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates button                                                   |
//+------------------------------------------------------------------+
bool CColorButton::CreateButton(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_color_button_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+CElement::XSize()-m_button_x_size;
   int y =CElement::Y()-1;
//--- Creating the object
   if(!m_button.Create(m_chart_id,name,m_subwin,x,y,m_button_x_size,m_button_y_size))
      return(false);
//--- set properties
   m_button.Font(FONT);
   m_button.FontSize(FONT_SIZE);
   m_button.Color(m_back_color);
   m_button.Description("");
   m_button.BorderColor(m_border_color);
   m_button.BackColor(m_back_color);
   m_button.Corner(m_corner);
   m_button.Anchor(m_anchor);
   m_button.Selectable(false);
   m_button.Z_Order(m_button_zorder);
   m_button.Tooltip("\n");
//--- Store coordinates
   m_button.X(x);
   m_button.Y(y);
//--- Store the size
   m_button.XSize(m_button_x_size);
   m_button.YSize(m_button_y_size);
//--- Margins from the edge
   m_button.XGap(x-m_wnd.X());
   m_button.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(m_back_color,m_back_color_hover,m_back_color_array);
   CElement::InitColorArray(m_border_color,m_border_color_hover,m_border_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the button icon                                          |
//+------------------------------------------------------------------+
bool CColorButton::CreateButtonIcon(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_color_button_bmp_"+(string)CElement::Id();
//--- Coordinates
   int x =m_button.X()+3;
   int y =m_button.Y()+3;
//--- Creating the object
   if(!m_button_icon.Create(m_chart_id,name,m_subwin,x,y,12,12))
      return(false);
//--- set properties
   m_button_icon.Corner(m_corner);
   m_button_icon.Color(clrGray);
   m_button_icon.BackColor(m_current_color);
   m_button_icon.Selectable(false);
   m_button_icon.Z_Order(m_button_zorder);
   m_button_icon.BorderType(BORDER_FLAT);
   m_button_icon.Tooltip("\n");
//--- Store coordinates
   m_button_icon.X(x);
   m_button_icon.Y(y);
//--- Store the size
   m_button_icon.XSize(m_button_icon.X_Size());
   m_button_icon.YSize(m_button_icon.Y_Size());
//--- Margins from the edge
   m_button_icon.XGap(x-m_wnd.X());
   m_button_icon.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_button_icon);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the button text                                          |
//+------------------------------------------------------------------+
bool CColorButton::CreateButtonLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_color_button_text_"+(string)CElement::Id();
//--- Coordinates
   int x =m_button.X()+m_label_x_gap;
   int y =m_button.Y()+m_label_y_gap;
//--- Creating the object
   if(!m_button_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_button_label.Description(::ColorToString(m_current_color));
   m_button_label.Font(FONT);
   m_button_label.FontSize(FONT_SIZE);
   m_button_label.Color(m_button_label_color);
   m_button_label.Corner(m_corner);
   m_button_label.Anchor(m_anchor);
   m_button_label.Selectable(false);
   m_button_label.Z_Order(m_zorder);
   m_button_label.Tooltip("\n");
//--- Margins from the edge
   m_button_label.XGap(x-m_wnd.X());
   m_button_label.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_button_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the current color of parameter                            |
//+------------------------------------------------------------------+
void CColorButton::CurrentColor(const color clr)
  {
   m_current_color=clr;
   m_button_icon.BackColor(clr);
   m_button_label.Description(::ColorToString(clr));
  }
//+------------------------------------------------------------------+
//| Changing the button state                                        |
//+------------------------------------------------------------------+
void CColorButton::ButtonState(const bool state)
  {
   m_button_state=state;
//--- Set colors corresponding to the current state to the object
   m_label.Color((state)? m_label_color : m_label_color_off);
   m_button_label.Color((state)? m_button_label_color : m_button_label_color_off);
   m_button.State(false);
   m_button.BackColor((state)? m_back_color : m_back_color_off);
   m_button.BorderColor((state)? m_border_color : m_border_color_off);
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CColorButton::ChangeObjectsColor(void)
  {
   color label_color=(m_button_state) ? m_label_color : m_label_color_off;
   CElement::ChangeObjectColor(m_label.Name(),CElement::MouseFocus(),OBJPROP_COLOR,label_color,m_label_color_hover,m_label_color_array);
   CElement::ChangeObjectColor(m_button.Name(),CElement::MouseFocus(),OBJPROP_BGCOLOR,m_back_color,m_back_color_hover,m_back_color_array);
   CElement::ChangeObjectColor(m_button.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_border_color,m_border_color_hover,m_border_color_array);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CColorButton::Moving(const int x,const int y)
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
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
   m_button.X(x+m_button.XGap());
   m_button.Y(y+m_button.YGap());
   m_button_icon.X(x+m_button_icon.XGap());
   m_button_icon.Y(y+m_button_icon.YGap());
   m_button_label.X(x+m_button_label.XGap());
   m_button_label.Y(y+m_button_label.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
   m_button.X_Distance(m_button.X());
   m_button.Y_Distance(m_button.Y());
   m_button_icon.X_Distance(m_button_icon.X());
   m_button_icon.Y_Distance(m_button_icon.Y());
   m_button_label.X_Distance(m_button_label.X());
   m_button_label.Y_Distance(m_button_label.Y());
  }
//+------------------------------------------------------------------+
//| Shows the button                                                 |
//+------------------------------------------------------------------+
void CColorButton::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the button                                                 |
//+------------------------------------------------------------------+
void CColorButton::Hide(void)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CColorButton::Reset(void)
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
void CColorButton::Delete(void)
  {
   m_area.Delete();
   m_label.Delete();
   m_button.Delete();
   m_button_icon.Delete();
   m_button_label.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CColorButton::SetZorders(void)
  {
   m_area.Z_Order(m_zorder);
   m_label.Z_Order(m_zorder);
   m_button.Z_Order(m_button_zorder);
   m_button_icon.Z_Order(m_zorder);
   m_button_label.Z_Order(m_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CColorButton::ResetZorders(void)
  {
   m_area.Z_Order(-1);
   m_label.Z_Order(-1);
   m_button.Z_Order(-1);
   m_button_icon.Z_Order(-1);
   m_button_label.Z_Order(-1);
  }
//+------------------------------------------------------------------+
//| Reset the color                                                  |
//+------------------------------------------------------------------+
void CColorButton::ResetColors(void)
  {
//--- Leave, if the element is blocked
   if(!m_button_state)
      return;
//--- Reset colors
   m_label.Color(m_label_color);
   m_button.BackColor(m_back_color);
   m_button.BorderColor(m_border_color);
//--- Zero the focus
   m_button.MouseFocus(false);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Pressing the button                                              |
//+------------------------------------------------------------------+
bool CColorButton::OnClickButton(const string clicked_object)
  {
//--- Leave, if the object name is different
   if(m_button.Name()!=clicked_object)
      return(false);
//--- Leave, if the button is blocked
   if(!m_button_state)
     {
      m_button.State(false);
      return(false);
     }
//--- Reset the state and color
   m_button.State(false);
   m_label.Color(m_label_color);
   m_button.BackColor(m_back_color);
   m_button.BorderColor(m_border_color);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElement::Id(),CElement::Index(),m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
