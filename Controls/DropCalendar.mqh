﻿//+------------------------------------------------------------------+
//|                                                 DropCalendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "Calendar.mqh"
//+------------------------------------------------------------------+
//| Class for creating a drop down calendar                          |
//+------------------------------------------------------------------+
class CDropCalendar : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects and elements for creating an element
   CRectLabel        m_area;
   CLabel            m_label;
   CEdit             m_field;
   CEdit             m_drop_button;
   CBmpLabel         m_drop_button_icon;
   CCalendar         m_calendar;
   //--- Background color
   color             m_area_color;
   //--- Displayed control description
   string            m_label_text;
   //--- Colors of the text label in different states
   color             m_label_color;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_array[];
   //--- Colors of edit in different states
   color             m_edit_color;
   color             m_edit_color_locked;
   //--- Colors of the combobox frame in different states
   color             m_border_color;
   color             m_border_color_hover;
   color             m_border_color_locked;
   color             m_border_color_array[];
   //--- Combobox sizes
   int               m_combobox_x_size;
   int               m_combobox_y_size;
   //--- Combobox button sizes
   int               m_button_x_size;
   int               m_button_y_size;
   //--- Colors of the button in different states
   color             m_button_color;
   color             m_button_color_hover;
   color             m_button_color_locked;
   color             m_button_color_pressed;
   color             m_button_color_array[];
   //--- Text color in the combobox edit box
   color             m_combobox_text_color;
   color             m_combobox_text_color_locked;
   //--- Icons for buttons
   string            m_icon_file_on;
   string            m_icon_file_off;
   string            m_icon_file_locked;
   //--- Priorities of the left mouse button press
   int               m_area_zorder;
   int               m_combobox_zorder;
   int               m_zorder;
   //--- Available/blocked
   bool              m_drop_calendar_state;
   //---
public:
                     CDropCalendar(void);
                    ~CDropCalendar(void);
   //--- Methods for creating a drop down calendar
   bool              CreateDropCalendar(const long chart_id,const int subwin,const string text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateLabel(void);
   bool              CreateEditBox(void);
   bool              CreateDropButton(void);
   bool              CreateDropButtonIcon(void);
   bool              CreateCalendar(void);
   //---
public:
   //--- (1) Store the form pointer, (2) get the calendar pointer, (3) return/set the state of the control
   void              WindowPointer(CWindow &object)          { m_wnd=::GetPointer(object);       }
   CCalendar        *GetCalendarPointer(void)                { return(::GetPointer(m_calendar)); }
   bool              DropCalendarState(void)           const { return(m_drop_calendar_state);    }
   void              DropCalendarState(const bool state);
   //--- (1) Combobox button size on the X axis, (2) combobox sizes
   void              ButtonXSize(const int x_size)           { m_button_x_size=x_size;           }
   void              ComboboxXSize(const int x_size)         { m_combobox_x_size=x_size;         }
   void              ComboboxYSize(const int y_size)         { m_combobox_y_size=y_size;         }
   //--- Setting and getting the displayed text description of the control
   void              LabelText(const string text)            { m_label_text=text;                }
   string            LabelText(void)                   const { return(m_label.Description());    }
   //--- (1) Set the background color, (2) colors of the text label in different states
   void              AreaBackColor(const color clr)          { m_area_color=clr;                 }
   void              LabelColor(const color clr)             { m_label_color=clr;                }
   void              LabelColorHover(const color clr)        { m_label_color_hover=clr;          }
   void              LabelColorLocked(const color clr)       { m_label_color_locked=clr;         }
   //--- Colors of edit in different states
   void              EditColor(const color clr)              { m_edit_color=clr;                 }
   void              EditColorLocked(const color clr)        { m_edit_color_locked=clr;          }
   //--- (1) Color of combobox button in different states, (2) text color in the combobox edit box
   void              ButtonColor(const color clr)            { m_button_color=clr;               }
   void              ButtonColorHover(const color clr)       { m_button_color_hover=clr;         }
   void              ButtonColorLocked(const color clr)      { m_button_color_locked=clr;        }
   void              ButtonColorPressed(const color clr)     { m_button_color_pressed=clr;       }
   void              ComboboxTextColor(const color clr)      { m_combobox_text_color=clr;        }
   //--- (1) Color of the combobox frame in different states
   void              BorderColor(const color clr)            { m_border_color=clr;               }
   void              BorderColorHover(const color clr)       { m_border_color_hover=clr;         }
   void              BorderColorLocked(const color clr)      { m_border_color_locked=clr;        }
   //--- Setting labels for the button in the active and blocked states
   void              IconFileOn(const string file_path)      { m_icon_file_on=file_path;         }
   void              IconFileOff(const string file_path)     { m_icon_file_off=file_path;        }
   void              IconFileLocked(const string file_path)  { m_icon_file_locked=file_path;     }
   //--- (1) Set (select) and (2) get the selected date
   void              SelectedDate(const datetime date);
   datetime          SelectedDate(void) { return(m_calendar.SelectedDate()); }
   //--- Changing the object colors
   void              ChangeObjectsColor(void);
   //--- Change the calendar visibility state for the opposite
   void              ChangeComboBoxCalendarState(void);
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
   //--- Handling of pressing the combobox button
   bool              OnClickButton(const string clicked_object);
   //--- Checking the pressed left mouse button over the combobox button
   void              CheckPressedOverButton(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDropCalendar::CDropCalendar(void) : m_drop_calendar_state(true),
                                     m_button_x_size(32),
                                     m_button_y_size(20),
                                     m_combobox_x_size(100),
                                     m_combobox_y_size(20),
                                     m_area_color(clrNONE),
                                     m_label_text("Drop calendar: "),
                                     m_label_color(clrBlack),
                                     m_label_color_hover(C'85,170,255'),
                                     m_label_color_locked(clrSilver),
                                     m_edit_color(clrWhite),
                                     m_edit_color_locked(clrWhiteSmoke),
                                     m_border_color(clrSilver),
                                     m_border_color_hover(C'85,170,255'),
                                     m_border_color_locked(clrSilver),
                                     m_button_color(C'220,220,220'),
                                     m_button_color_hover(C'193,218,255'),
                                     m_button_color_locked(C'230,230,230'),
                                     m_button_color_pressed(C'153,178,215'),
                                     m_combobox_text_color(clrBlack),
                                     m_combobox_text_color_locked(clrSilver),
                                     m_icon_file_on(""),
                                     m_icon_file_off(""),
                                     m_icon_file_locked("")

  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_area_zorder     =1;
   m_combobox_zorder =2;
   m_zorder          =0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDropCalendar::~CDropCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CDropCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- Verifying the focus
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      m_drop_button.MouseFocus(m_mouse.X()>m_drop_button.X() && m_mouse.X()<m_drop_button.X2() && 
                               m_mouse.Y()>m_drop_button.Y() && m_mouse.Y()<m_drop_button.Y2());
      //--- Checking the pressed left mouse button over the combobox button
      CheckPressedOverButton();
      return;
     }
//--- Handle event of new date selection in the calendar
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_DATE)
     {
      //--- Leave, if control identifiers do not match
      if(lparam!=CElement::Id())
         return;
      //--- Set a new date in the combo box field
      m_field.Description(::TimeToString((datetime)dparam,TIME_DATE));
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Pressing on the combobox button
      if(OnClickButton(sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CDropCalendar::OnEventTimer(void)
  {
//--- If the element is a drop-down
   if(CElement::IsDropdown())
      ChangeObjectsColor();
   else
     {
      //--- Track the change of color only if the form is not blocked
      if(!m_wnd.IsLocked())
         ChangeObjectsColor();
     }
  }
//+------------------------------------------------------------------+
//| Create drop down calendar                                        |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDropCalendar(const long chart_id,const int subwin,const string text,const int x,const int y)
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
   m_label_text =text;
   m_area_color =(m_area_color!=clrNONE)? m_area_color : m_wnd.WindowBgColor();
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating an element
   if(!CreateArea())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateEditBox())
      return(false);
   if(!CreateDropButton())
      return(false);
   if(!CreateDropButtonIcon())
      return(false);
   if(!CreateCalendar())
      return(false);
//--- Hide calendar
   m_calendar.Hide();
//--- Display selected date in the calendar
   m_field.Description(::TimeToString((datetime)m_calendar.SelectedDate(),TIME_DATE));
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates combobox area                                            |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_dc_combobox_area_"+(string)CElement::Id();
//--- Set the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_button_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_color);
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
//| Creates combobox label                                           |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_dc_combobox_lable_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y()+2;
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_label.Description(m_label_text);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(m_label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
   m_label.Tooltip("\n");
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(m_label_color,m_label_color_hover,m_label_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create date and time edit box                                    |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateEditBox(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_dc_combobox_edit_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+CElement::XSize()-m_combobox_x_size;
   int y =CElement::Y()-1;
//--- Set the object
   if(!m_field.Create(m_chart_id,name,m_subwin,x,y,m_combobox_x_size,m_combobox_y_size))
      return(false);
//--- Setting the properties
   m_field.Font(FONT);
   m_field.FontSize(FONT_SIZE);
   m_field.Color(m_combobox_text_color);
   m_field.Description("");
   m_field.BorderColor(m_border_color);
   m_field.BackColor(m_edit_color);
   m_field.Corner(m_corner);
   m_field.Anchor(m_anchor);
   m_field.Selectable(false);
   m_field.Z_Order(m_combobox_zorder);
   m_field.ReadOnly(true);
   m_field.Tooltip("\n");
//--- Store coordinates
   m_field.X(x);
   m_field.Y(y);
//--- Store the size
   m_field.XSize(m_combobox_x_size);
   m_field.YSize(m_combobox_y_size);
//--- Margins from the edge
   m_field.XGap(x-m_wnd.X());
   m_field.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_field);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates combobox button                                          |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDropButton(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_dc_combobox_button_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+CElement::XSize()-m_button_x_size;
   int y =CElement::Y()-1;
//--- Set the object
   if(!m_drop_button.Create(m_chart_id,name,m_subwin,x,y,m_button_x_size,m_combobox_y_size))
      return(false);
//--- Setting the properties
   m_drop_button.Font(FONT);
   m_drop_button.FontSize(FONT_SIZE);
   m_drop_button.Color(m_combobox_text_color);
   m_drop_button.Description("");
   m_drop_button.BorderColor(m_border_color);
   m_drop_button.BackColor(m_button_color);
   m_drop_button.Corner(m_corner);
   m_drop_button.Anchor(m_anchor);
   m_drop_button.Selectable(false);
   m_drop_button.Z_Order(m_combobox_zorder);
   m_drop_button.ReadOnly(true);
   m_drop_button.Tooltip("\n");
//--- Store coordinates
   m_drop_button.X(x);
   m_drop_button.Y(y);
//--- Store the size
   m_drop_button.XSize(m_button_x_size);
   m_drop_button.YSize(m_combobox_y_size);
//--- Margins from the edge
   m_drop_button.XGap(x-m_wnd.X());
   m_drop_button.YGap(y-m_wnd.Y());
//--- Initializing gradient arrays
   CElement::InitColorArray(m_border_color,m_border_color_hover,m_border_color_array);
   CElement::InitColorArray(m_button_color,m_button_color_hover,m_button_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_drop_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create icon on combobox button                                   |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_locked.bmp"
//---
bool CDropCalendar::CreateDropButtonIcon(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_dc_combobox_icon_"+(string)CElement::Id();
//--- Coordinates
   int x=m_drop_button.X()+m_button_x_size-25;
   int y=CElement::Y()+1;
//--- If the icon is not defined, set the default one
   if(m_icon_file_on=="")
      m_icon_file_on="Images\\EasyAndFastGUI\\Controls\\calendar_drop_on.bmp";
   if(m_icon_file_off=="")
      m_icon_file_off="Images\\EasyAndFastGUI\\Controls\\calendar_drop_off.bmp";
   if(m_icon_file_locked=="")
      m_icon_file_locked="Images\\EasyAndFastGUI\\Controls\\calendar_drop_locked.bmp";
//--- Set the object
   if(!m_drop_button_icon.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_drop_button_icon.BmpFileOn("::"+m_icon_file_on);
   m_drop_button_icon.BmpFileOff("::"+m_icon_file_off);
   m_drop_button_icon.Corner(m_corner);
   m_drop_button_icon.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_drop_button_icon.Selectable(false);
   m_drop_button_icon.Z_Order(m_zorder);
   m_drop_button_icon.Tooltip("\n");
//--- Store the size (in the object)
   m_drop_button_icon.XSize(m_drop_button_icon.X_Size());
   m_drop_button_icon.YSize(m_drop_button_icon.Y_Size());
//--- Store coordinates
   m_drop_button_icon.X(x);
   m_drop_button_icon.Y(y);
//--- Margins from the edge
   m_drop_button_icon.XGap(x-m_wnd.X());
   m_drop_button_icon.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_drop_button_icon);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the list view                                            |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateCalendar(void)
  {
//--- Pass the panel object
   m_calendar.WindowPointer(m_wnd);
//--- Coordinates
   int x=m_field.X();
   int y=m_field.Y2();
//--- Set the drop down element sign for the calendar
   m_calendar.IsDropdown(true);
//--- Create control
   if(!m_calendar.CreateCalendar(m_chart_id,m_subwin,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Set a new date in the calendar                                   |
//+------------------------------------------------------------------+
void CDropCalendar::SelectedDate(const datetime date)
  {
//--- Set and store the date
   m_calendar.SelectedDate(date);
//--- Display date in the combobox edit box
   m_field.Description(::TimeToString(date,TIME_DATE));
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CDropCalendar::ChangeObjectsColor(void)
  {
//--- Leave, if the element is blocked
   if(!m_drop_calendar_state)
      return;
//---
   CElement::ChangeObjectColor(m_label.Name(),CElement::MouseFocus(),OBJPROP_COLOR,m_label_color,m_label_color_hover,m_label_color_array);
   CElement::ChangeObjectColor(m_field.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_border_color,m_border_color_hover,m_border_color_array);
   CElement::ChangeObjectColor(m_drop_button.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_border_color,m_border_color_hover,m_border_color_array);
   CElement::ChangeObjectColor(m_drop_button.Name(),m_drop_button.MouseFocus(),OBJPROP_BGCOLOR,m_button_color,m_button_color_hover,m_button_color_array);
  }
//+------------------------------------------------------------------+
//| Change the state of the control                                  |
//+------------------------------------------------------------------+
void CDropCalendar::DropCalendarState(const bool state)
  {
   m_drop_calendar_state=state;
//--- Icon
   m_drop_button_icon.BmpFileOff((state)? "::"+m_icon_file_on : "::"+m_icon_file_locked);
//--- Color of the text label
   m_label.Color((state)? m_label_color : m_label_color_locked);
//--- Colors of the edit box
   m_field.BackColor((state)? m_edit_color : m_edit_color_locked);
   m_field.Color((state)? m_combobox_text_color : m_combobox_text_color_locked);
   m_field.BorderColor((state)? m_border_color : m_border_color_locked);
//--- Colors of the combo-box button
   m_drop_button.BackColor((state)? m_button_color : m_button_color_locked);
   m_drop_button.BorderColor((state)? m_border_color : m_border_color_locked);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CDropCalendar::Moving(const int x,const int y)
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
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
   m_field.X(x+m_field.XGap());
   m_field.Y(y+m_field.YGap());
   m_drop_button.X(x+m_drop_button.XGap());
   m_drop_button.Y(y+m_drop_button.YGap());
   m_drop_button_icon.X(x+m_drop_button_icon.XGap());
   m_drop_button_icon.Y(y+m_drop_button_icon.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
   m_field.X_Distance(m_field.X());
   m_field.Y_Distance(m_field.Y());
   m_drop_button.X_Distance(m_drop_button.X());
   m_drop_button.Y_Distance(m_drop_button.Y());
   m_drop_button_icon.X_Distance(m_drop_button_icon.X());
   m_drop_button_icon.Y_Distance(m_drop_button_icon.Y());
  }
//+------------------------------------------------------------------+
//| Shows the element                                                |
//+------------------------------------------------------------------+
void CDropCalendar::Show(void)
  {
   m_area.Timeframes(OBJ_ALL_PERIODS);
   m_label.Timeframes(OBJ_ALL_PERIODS);
   m_field.Timeframes(OBJ_ALL_PERIODS);
   m_drop_button.Timeframes(OBJ_ALL_PERIODS);
   m_drop_button_icon.Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the element                                                |
//+------------------------------------------------------------------+
void CDropCalendar::Hide(void)
  {
   m_area.Timeframes(OBJ_NO_PERIODS);
   m_label.Timeframes(OBJ_NO_PERIODS);
   m_field.Timeframes(OBJ_NO_PERIODS);
   m_drop_button.Timeframes(OBJ_NO_PERIODS);
   m_drop_button_icon.Timeframes(OBJ_NO_PERIODS);
   m_calendar.Hide();
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CDropCalendar::Reset(void)
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
void CDropCalendar::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_label.Delete();
   m_field.Delete();
   m_drop_button.Delete();
   m_drop_button_icon.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CDropCalendar::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_label.Z_Order(m_zorder);
   m_field.Z_Order(m_combobox_zorder);
   m_drop_button.Z_Order(m_combobox_zorder);
   m_drop_button_icon.Z_Order(m_zorder);
   m_calendar.SetZorders();
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CDropCalendar::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_label.Z_Order(0);
   m_field.Z_Order(0);
   m_drop_button.Z_Order(0);
   m_drop_button_icon.Z_Order(0);
   m_calendar.ResetZorders();
  }
//+------------------------------------------------------------------+
//| Reset colors of all objects                                      |
//+------------------------------------------------------------------+
void CDropCalendar::ResetColors(void)
  {
   m_label.Color(m_label_color);
   m_field.BorderColor(m_border_color);
   m_drop_button.BackColor(m_button_color);
   m_drop_button.BorderColor(m_border_color);
  }
//+------------------------------------------------------------------+
//| Change the calendar visibility state for the opposite            |
//+------------------------------------------------------------------+
void CDropCalendar::ChangeComboBoxCalendarState(void)
  {
//--- If the calendar is opened
   if(m_calendar.IsVisible())
     {
      //--- Hide it and set the corresponding values to the button properties
      m_calendar.Hide();
      m_drop_button_icon.State(false);
      m_label.Color(m_label_color_hover);
      m_field.BorderColor(m_border_color_hover);
      m_drop_button.BorderColor(m_border_color_hover);
      m_drop_button.BackColor(m_button_color_hover);
      //--- Unblock the form
      m_wnd.IsLocked(false);
      m_wnd.IdActivatedElement(WRONG_VALUE);
     }
//--- If the calendar is hidden
   else
     {
      //--- Open it and set the corresponding values to the button properties
      m_calendar.Show();
      m_drop_button_icon.State(true);
      m_drop_button.BackColor(m_button_color_pressed);
      //--- Block the form
      m_wnd.IsLocked(true);
      m_wnd.IdActivatedElement(CElement::Id());
     }
  }
//+------------------------------------------------------------------+
//| Pressing on the combobox button                                  |
//+------------------------------------------------------------------+
bool CDropCalendar::OnClickButton(const string clicked_object)
  {
//--- Leave, if pressed not the combobox button
   if(clicked_object!=m_drop_button.Name())
      return(false);
//--- Leave, if the form is blocked and identifiers do not match
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return(false);
//--- Leave, if the element is blocked
   if(!m_drop_calendar_state)
      return(false);
//--- Change the calendar visibility state for the opposite
   ChangeComboBoxCalendarState();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_BUTTON,CElement::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Check of the pressed left mouse button over the button           |
//+------------------------------------------------------------------+
void CDropCalendar::CheckPressedOverButton(void)
  {
//--- Leave, if the left mouse button is released
   if(!m_mouse.LeftButtonState())
      return;
//--- Leave, if the element is blocked
   if(!m_drop_calendar_state)
      return;
//--- If the focus is on the element
   if(CElement::MouseFocus())
     {
      //--- Leave, if the form is blocked and identifiers do not match
      if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
         return;
      //--- If the calendar is hidden
      if(!m_calendar.IsVisible())
        {
         //--- Set the button color relative to the mouse cursor
         if(m_drop_button.MouseFocus())
            m_drop_button.BackColor(m_button_color_pressed);
         else
            m_drop_button.BackColor(m_button_color);
        }
     }
//--- If the focus is not on the element
   else
     {
      //--- Leave, if the focus is on the calendar
      if(m_calendar.MouseFocus())
         return;
      //--- Leave, if the scrollbar of the calendar month list is active
      if(m_calendar.GetScrollVPointer().ScrollState())
         return;
      //--- Hide the calendar and reset the colors of objects
      m_calendar.Hide();
      m_drop_button_icon.State(false);
      //--- Reset colors
      ResetColors();
      //--- Unblock the form if the identifiers of the control and activator match
      if(m_wnd.IdActivatedElement()==CElement::Id())
         m_wnd.IsLocked(false);
     }
  }
//+------------------------------------------------------------------+
