//+------------------------------------------------------------------+
//|                                                 SimpleButton.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a simple button                               |
//+------------------------------------------------------------------+
class CSimpleButton : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Object for creating a button
   CButton           m_button;
   //--- Button properties:
   //    (1) Text, (2) size
   string            m_button_text;
   int               m_button_x_size;
   int               m_button_y_size;
   //--- Background colors
   color             m_back_color;
   color             m_back_color_off;
   color             m_back_color_hover;
   color             m_back_color_pressed;
   color             m_back_color_array[];
   //--- Frame color
   color             m_border_color;
   color             m_border_color_off;
   //--- Text color
   color             m_text_color;
   color             m_text_color_off;
   color             m_text_color_pressed;
   //--- Priority of left mouse click
   int               m_button_zorder;
   //--- Mode of two button states
   bool              m_two_state;
   //--- Available/blocked
   bool              m_button_state;
   bool              isCreated;
   //---
public:
                     CSimpleButton(void);
                    ~CSimpleButton(void);
   //--- Methods for creating a simple button
   bool              CreateSimpleButton(const long chart_id,const int subwin,const string button_text,const int x,const int y);
   //---
private:
   bool              CreateButton(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) sets the button mode
   //    (3) general state of the button (available/blocked)
   void              WindowPointer(CWindow &object)          { m_wnd=::GetPointer(object);     }
   void              TwoState(const bool flag)               { m_two_state=flag;               }
   bool              IsPressed(void)                   const { return(m_button.State());       }
   bool              ButtonState(void)                 const { return(m_button_state);         }
   void              ButtonState(const bool state);
   //--- Button size
   void              ButtonXSize(const int x_size)           { m_button_x_size=x_size;         }
   void              ButtonYSize(const int y_size)           { m_button_y_size=y_size;         }
   //--- (1) Returns the button text, (2) setting up the color of the button text
   string            Text(void)                        const { return(m_button.Description()); }
   void              Text(const string text)                 { m_button.Description(text); }
   void              TextColor(const color clr)              { m_text_color=clr; isCreated ? m_button.Color(clr) : m_text_color=clr;}
   color             TextColor(void)                   const { return(m_text_color); }
   void              TextColorOff(const color clr)           { m_text_color_off=clr;           }
   void              TextColorPressed(const color clr)       { m_text_color_pressed=clr;       }
   //--- Setting up the color of the button background
   void              BackColor(const color clr)              { m_back_color=clr; isCreated ? m_button.BackColor(clr) : m_back_color=clr;}
   color             BackColor(void)                   const { return(m_back_color); }
   void              BackColorOff(const color clr)           { m_back_color_off=clr;           }
   void              BackColorHover(const color clr)         { m_back_color_hover=clr;         }
   void              BackColorPressed(const color clr)       { m_back_color_pressed=clr;       }
   //--- Setting up the color of the button frame
   void              BorderColor(const color clr)            {m_border_color=clr; isCreated ? m_button.BorderColor(clr) : m_border_color=clr;}
   color             BorderColor(void)                   const { return(m_border_color); }
   void              BorderColorOff(const color clr)         { m_border_color_off=clr;         }

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
CSimpleButton::CSimpleButton(void) : m_button_state(true),
                                     m_two_state(false),
                                     m_button_x_size(50),
                                     m_button_y_size(22),
                                     m_text_color(clrBlack),
                                     m_text_color_off(clrDarkGray),
                                     m_text_color_pressed(clrBlack),
                                     m_back_color(clrGainsboro),
                                     m_back_color_off(clrLightGray),
                                     m_back_color_hover(C'193,218,255'),
                                     m_back_color_pressed(C'190,190,200'),
                                     m_border_color(C'150,170,180'),
                                     m_border_color_off(C'178,195,207'),
                                     isCreated(false)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priority of the left mouse button click
   m_button_zorder=1;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSimpleButton::~CSimpleButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handling                                                |
//+------------------------------------------------------------------+
void CSimpleButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling of the cursor movement event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the element is hidden
      if(!CElement::IsVisible())
         return;
      //--- Leave, if the form is blocked
      if(m_wnd.IsLocked())
         return;
      //--- Leave, if numbers of subwindows do not match
      if(CElement::m_subwin!=CElement::m_mouse.SubWindowNumber())
         return;
      //--- Leave, if the button is blocked
      if(!m_button_state)
         return;
      //--- Define the focus
      CElement::MouseFocus(CElement::m_mouse.X()>X() && CElement::m_mouse.X()<X2() && 
                           CElement::m_mouse.Y()>Y() && CElement::m_mouse.Y()<Y2());
      //--- Leave, if the mouse button is unpressed
      if(!CElement::m_mouse.LeftButtonState())
         return;
      //--- If there is no focus
      if(!CElement::MouseFocus())
        {
         //--- If the button is unpressed
         if(!m_button.State())
           {
            m_button.Color(m_text_color);
            m_button.BackColor(m_back_color);
           }
         //---
         return;
        }
      //--- If there is focus
      else
        {
         m_button.Color(m_text_color_pressed);
         m_button.BackColor(m_back_color_pressed);
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
void CSimpleButton::OnEventTimer(void)
  {
//--- If this is a drop-down element
   if(CElement::IsDropdown())
      ChangeObjectsColor();
   else
     {
      //--- If the form is not blocked
      if(!m_wnd.IsLocked())
         ChangeObjectsColor();
     }
  }
//+------------------------------------------------------------------+
//| Create a "Simple button" control                                 |
//+------------------------------------------------------------------+
bool CSimpleButton::CreateSimpleButton(const long chart_id,const int subwin,const string button_text,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id          =m_wnd.LastId()+1;
   m_chart_id    =chart_id;
   m_subwin      =subwin;
   m_x           =x;
   m_y           =y;
   m_button_text =button_text;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating a button
   if(!CreateButton())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates button                                                   |
//+------------------------------------------------------------------+
bool CSimpleButton::CreateButton(void)
  {
//--- Forming the object name
   string name="";
//--- If the index has not been specified
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_simple_button_"+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+"_simple_button_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Set up a button
   if(!m_button.Create(m_chart_id,name,m_subwin,m_x,m_y,m_button_x_size,m_button_y_size))
      return(false);
//--- set properties
   m_button.Font(FONT);
   m_button.FontSize(FONT_SIZE);
   m_button.Color(m_text_color);
   m_button.Description(m_button_text);
   m_button.BackColor(m_back_color);
   m_button.BorderColor(m_border_color);
   m_button.Corner(m_corner);
   m_button.Anchor(m_anchor);
   m_button.Selectable(false);
   m_button.Z_Order(m_button_zorder);
   m_button.Tooltip("\n");
//--- Store the size
   CElement::XSize(m_button_x_size);
   CElement::YSize(m_button_y_size);
//--- Margins from the edge
   m_button.XGap(m_x-m_wnd.X());
   m_button.YGap(m_y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(m_back_color,m_back_color_hover,m_back_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_button);
   isCreated = true;
   return(true);
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CSimpleButton::ChangeObjectsColor(void)
  {
   ChangeObjectColor(m_button.Name(),CElement::MouseFocus(),OBJPROP_BGCOLOR,m_back_color,m_back_color_hover,m_back_color_array);
  }
//+------------------------------------------------------------------+
//| Reset the color                                                  |
//+------------------------------------------------------------------+
void CSimpleButton::ResetColors(void)
  {
//--- Leave, if this is the two-state mode and the button is pressed
   if(m_two_state && m_button_state)
      return;
//--- Reset the color
   m_button.BackColor(m_back_color);
//--- Zero the focus
   m_button.MouseFocus(false);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Changing the button state                                        |
//+------------------------------------------------------------------+
void CSimpleButton::ButtonState(const bool state)
  {
   m_button_state=state;
   m_button.State(false);
   m_button.Color((state)? m_text_color : m_text_color_off);
   m_button.BackColor((state)? m_back_color : m_back_color_off);
   m_button.BorderColor((state)? m_border_color : m_border_color_off);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CSimpleButton::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing coordinates in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_button.X(x+m_button.XGap());
   m_button.Y(y+m_button.YGap());
//--- Updating coordinates of graphical objects
   m_button.X_Distance(m_button.X());
   m_button.Y_Distance(m_button.Y());
  }
//+------------------------------------------------------------------+
//| Shows the button                                                 |
//+------------------------------------------------------------------+
void CSimpleButton::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   m_button.Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the button                                                 |
//+------------------------------------------------------------------+
void CSimpleButton::Hide(void)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   m_button.Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CSimpleButton::Reset(void)
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
void CSimpleButton::Delete(void)
  {
//--- Removing objects
   m_button.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CSimpleButton::SetZorders(void)
  {
   m_button.Z_Order(m_button_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CSimpleButton::ResetZorders(void)
  {
   m_button.Z_Order(-1);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of a button                                |
//+------------------------------------------------------------------+
bool CSimpleButton::OnClickButton(const string clicked_object)
  {
//--- Check for the object name
   if(m_button.Name()!=clicked_object)
      return(false);
//--- If the button is blocked
   if(!m_button_state)
     {
      m_button.State(false);
      return(false);
     }
//--- If the button mode has one state
   if(!m_two_state)
     {
      m_button.State(false);
      m_button.Color(m_text_color);
      m_button.BackColor(m_back_color);
     }
//--- If the button mode has two states
   else
     {
      //--- If pressed down
      if(m_button.State())
        {
         //--- Change the button color 
         m_button.State(true);
         m_button.Color(m_text_color_pressed);
         m_button.BackColor(m_back_color_pressed);
         CElement::InitColorArray(m_back_color_pressed,m_back_color_pressed,m_back_color_array);
        }
      //--- If the button is unpressed
      else
        {
         //--- Change the button color 
         m_button.State(false);
         m_button.Color(m_text_color);
         m_button.BackColor(m_back_color);
         CElement::InitColorArray(m_back_color,m_back_color_hover,m_back_color_array);
        }
     }
//--- Send a signal about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElement::Id(),CElement::Index(),m_button.Description());
   return(true);
  }
//+------------------------------------------------------------------+
