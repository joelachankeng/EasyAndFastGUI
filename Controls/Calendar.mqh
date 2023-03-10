//+------------------------------------------------------------------+
//|                                                     Calendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "SpinEdit.mqh"
#include "ComboBox.mqh"
#include "IconButton.mqh"
#include <Tools\DateTime.mqh>
//+------------------------------------------------------------------+
//| Class for creating the calendar                                  |
//+------------------------------------------------------------------+
class CCalendar : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects and elements for creating a calendar
   CRectLabel        m_area;
   CBmpLabel         m_month_dec;
   CBmpLabel         m_month_inc;
   CComboBox         m_months;
   CSpinEdit         m_years;
   CEdit             m_days_week[7];
   CRectLabel        m_sep_line;
   CEdit             m_days[42];
   CIconButton       m_button_today;
   //--- Instances of the structure for working with dates and time:
   CDateTime         m_date;      // date selected by user
   CDateTime         m_today;     // current date (system date on a user's PC)
   CDateTime         m_temp_date; // instance for calculations and checks
   //--- Background color
   color             m_area_color;
   //--- Color of the background frame
   color             m_area_border_color;
   //--- Colors of calendar items (dates) in different states
   color             m_item_back_color;
   color             m_item_back_color_off;
   color             m_item_back_color_hover;
   color             m_item_back_color_selected;
   //--- Colors of item borders in different states
   color             m_item_border_color;
   color             m_item_border_color_hover;
   color             m_item_border_color_selected;
   //--- Colors of item text in different states
   color             m_item_text_color;
   color             m_item_text_color_off;
   color             m_item_text_color_hover;
   //--- Color of separation line
   color             m_sepline_color;
   //--- Labels of buttons (in active/blocked state) to move to previous/following month
   string            m_left_arrow_file_on;
   string            m_left_arrow_file_off;
   string            m_right_arrow_file_on;
   string            m_right_arrow_file_off;
   //--- Priorities of the left mouse button press
   int               m_area_zorder;
   int               m_button_zorder;
   int               m_zorder;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CCalendar(void);
                    ~CCalendar(void);
   //--- Methods for creating the calendar
   bool              CreateCalendar(const long chart_id,const int subwin,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateMonthDecArrow(void);
   bool              CreateMonthIncArrow(void);
   bool              CreateMonthsList(void);
   bool              CreateYearsSpinEdit(void);
   bool              CreateDaysWeek(void);
   bool              CreateSeparateLine(void);
   bool              CreateDaysMonth(void);
   bool              CreateButtonToday(void);
   //---
public:
   //--- (1) Store the form pointer, (2) get the combo-box pointer, 
   //    (3) get list pointer, (4) get list scrollbar pointer, 
   //    (5) get edit box pointer, (6) get button pointer
   void              WindowPointer(CWindow &object)             { m_wnd=::GetPointer(object);            }
   CComboBox        *GetComboBoxPointer(void)                   { return(::GetPointer(m_months));        }
   CListView        *GetListViewPointer(void)                   { return(m_months.GetListViewPointer()); }
   CScrollV         *GetScrollVPointer(void)                    { return(m_months.GetScrollVPointer());  }
   CSpinEdit        *GetSpinEditPointer(void)                   { return(::GetPointer(m_years));         }
   CIconButton      *GetIconButtonPointer(void)                 { return(::GetPointer(m_button_today));  }
   //--- Set the color of (1) area, (2) area border, (3) and separation line
   void              AreaBackColor(const color clr)             { m_area_color=clr;                      }
   void              AreaBorderColor(const color clr)           { m_area_border_color=clr;               }
   void              SeparateLineColor(const color clr)         { m_sepline_color=clr;                   }
   //--- Colors of calendar items (dates) in different states
   void              ItemBackColor(const color clr)             { m_item_back_color=clr;                 }
   void              ItemBackColorOff(const color clr)          { m_item_back_color_off=clr;             }
   void              ItemBackColorHover(const color clr)        { m_item_back_color_hover=clr;           }
   void              ItemBackColorSelected(const color clr)     { m_item_back_color_selected=clr;        }
   //--- Colors of item borders in different states
   void              ItemBorderColor(const color clr)           { m_item_border_color=clr;               }
   void              ItemBorderColorHover(const color clr)      { m_item_border_color_hover=clr;         }
   void              ItemBorderColorSelected(const color clr)   { m_item_border_color_selected=clr;      }
   //--- Colors of item text in different states
   void              ItemTextColor(const color clr)             { m_item_text_color=clr;                 }
   void              ItemTextColorOff(const color clr)          { m_item_text_color_off=clr;             }
   void              ItemTextColorHover(const color clr)        { m_item_text_color_hover=clr;           }
   //--- Setting labels of buttons (in active/blocked state) to move to a previous/following month
   void              LeftArrowFileOn(const string file_path)    { m_left_arrow_file_on=file_path;        }
   void              LeftArrowFileOff(const string file_path)   { m_left_arrow_file_off=file_path;       }
   void              RightArrowFileOn(const string file_path)   { m_right_arrow_file_on=file_path;       }
   void              RightArrowFileOff(const string file_path)  { m_right_arrow_file_off=file_path;      }
   //--- (1) Set (select) and (2) get a selected date, (3) get a current date in the calendar
   void              SelectedDate(const datetime date);
   datetime          SelectedDate(void)                         { return(m_date.DateTime());             }
   datetime          Today(void)                                { return(m_today.DateTime());            }
   //--- Changing the object colors
   void              ChangeObjectsColor(void);
   //--- Change of color of the object in the calendar's table when hovered
   void              ChangeObjectsColor(const int x,const int y);
   //--- Display last changes in the calendar
   void              UpdateCalendar(void);
   //--- Update the current date
   void              UpdateCurrentDate(void);
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
   virtual void      ResetColors(void) {}
   //---
private:
   //--- Handle clicking on the button to go to a previous month
   bool              OnClickMonthDec(const string clicked_object);
   //--- Handle clicking on the button to go to a following month
   bool              OnClickMonthInc(const string clicked_object);
   //--- Handle month selection in the list
   bool              OnClickMonthList(const long id);
   //--- Handle value entry to the year entry field
   bool              OnEndEnterYear(const string edited_object);
   //--- Handle clicking on the button to switch to a next year
   bool              OnClickYearInc(const long id);
   //--- Handle clicking on the button to go to a previous year
   bool              OnClickYearDec(const long id);
   //--- Handle clicking on a day of a month
   bool              OnClickDayOfMonth(const string clicked_object);
   //--- Handle clicking the button to go to a current date
   bool              OnClickTodayButton(const long id);

   //--- Correcting the selected day by the number of days in a month
   void              CorrectingSelectedDay(void);
   //--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   int               OffsetFirstDayOfMonth(void);
   //--- Display last changes in the calendar table
   void              SetCalendar(void);
   //--- Fast switching of calendar values
   void              FastSwitching(void);
   //--- Highlight the current date and the user selected date
   void              HighlightDate(void);
   //--- Reset time to midnight
   void              ResetTime(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCalendar::CCalendar(void) : m_area_color(clrWhite),
                             m_area_border_color(clrSilver),
                             m_sepline_color(clrBlack),
                             m_item_back_color(clrWhite),
                             m_item_back_color_off(clrWhite),
                             m_item_back_color_hover(C'235,245,255'),
                             m_item_back_color_selected(C'193,218,255'),
                             m_item_border_color(clrWhite),
                             m_item_border_color_hover(C'160,220,255'),
                             m_item_border_color_selected(C'85,170,255'),
                             m_item_text_color(clrBlack),
                             m_item_text_color_off(C'200,200,200'),
                             m_item_text_color_hover(C'0,102,204'),
                             m_left_arrow_file_on(""),
                             m_left_arrow_file_off(""),
                             m_right_arrow_file_on(""),
                             m_right_arrow_file_off("")
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder        =0;
   m_area_zorder   =1;
   m_button_zorder =2;
//--- Initialization of time structures
   m_date.DateTime(::TimeLocal());
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCalendar::~CCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- Exit if it is not a drop-down element and the form is blocked
      if(!CElement::IsDropdown() && m_wnd.IsLocked())
         return;
      //--- Verifying the focus
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      m_month_dec.MouseFocus(m_mouse.X()>m_month_dec.X() && m_mouse.X()<m_month_dec.X2() && 
                             m_mouse.Y()>m_month_dec.Y() && m_mouse.Y()<m_month_dec.Y2());
      m_month_inc.MouseFocus(m_mouse.X()>m_month_inc.X() && m_mouse.X()<m_month_inc.X2() && 
                             m_mouse.Y()>m_month_inc.Y() && m_mouse.Y()<m_month_inc.Y2());
      //--- Exit if a list of months is active
      if(m_months.GetListViewPointer().IsVisible())
         return;
      //--- If a list is not active and the left mouse of the button is clicked...
      else if(m_mouse.LeftButtonState())
        {
         //--- ...activate elements that are previously blocked (at the moment of opening the list),
         //       if one of them is not unblocked yet
         if(!m_button_today.ButtonState())
           {
            m_years.SpinEditState(true);
            m_button_today.ButtonState(true);
           }
        }
      //--- Changing the object colors
      ChangeObjectsColor(m_mouse.X(),m_mouse.Y());
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Leave, if the form is blocked and identifiers do not match
      if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
         return;
      //--- Exit if a list of months is activated
      if(m_months.GetListViewPointer().IsVisible())
         return;
      //--- Activate elements (list and entry field), if the left button of the mouse is clicked 
      if(m_mouse.LeftButtonState())
        {
         m_years.SpinEditState(true);
         m_button_today.ButtonState(true);
        }
      //--- Handle clicking on buttons of switching months
      if(OnClickMonthDec(sparam))
         return;
      if(OnClickMonthInc(sparam))
         return;
      //--- Handle pressing on the day of the calendar
      if(OnClickDayOfMonth(sparam))
         return;
     }
//--- Handle event of clicking combo box button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_BUTTON)
     {
      //--- Leave, if control identifiers do not match
      if(lparam!=CElement::Id())
         return;
      //--- Activate or block elements depending on the current state of visibility
      m_years.SpinEditState(!m_months.GetListViewPointer().IsVisible());
      m_button_today.ButtonState(!m_months.GetListViewPointer().IsVisible());
     }
//--- Handling the event of clicking on the item of the combo box list
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      //--- Handle month selection in the list
      if(!OnClickMonthList(lparam))
         return;
      //---
      return;
     }
//--- Handle the event of clicking the increment button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_INC)
     {
      //--- Handle clicking on the button to switch to a next year
      if(!OnClickYearInc(lparam))
         return;
      //---
      return;
     }
//--- Handle the even of clicking the decrement button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_DEC)
     {
      //--- Handle clicking on the button to go to a previous year
      if(!OnClickYearDec(lparam))
         return;
      //---
      return;
     }
//--- Handle event of entering value to the entry field
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //--- Handle value entry to the year entry field
      if(OnEndEnterYear(sparam))
         return;
      //---
      return;
     }
//--- Handle event of clicking on the button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Handle clicking the button to go to a current date
      if(!OnClickTodayButton(lparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CCalendar::OnEventTimer(void)
  {
//--- If this is a drop-down element and the list view is hidden
   if(CElement::IsDropdown() && !m_months.GetListViewPointer().IsVisible())
     {
      ChangeObjectsColor();
      FastSwitching();
     }
   else
     {
      //--- Track the change of color and the fast scrolling of values 
      //    only if the form is not blocked
      if(!m_wnd.IsLocked())
        {
         ChangeObjectsColor();
         FastSwitching();
        }
     }
//--- Update of the current date of the calendar
   UpdateCurrentDate();
  }
//+------------------------------------------------------------------+
//| Creates a context menu                                           |
//+------------------------------------------------------------------+
bool CCalendar::CreateCalendar(const long chart_id,const int subwin,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id       =m_wnd.LastId()+1;
   m_chart_id =chart_id;
   m_subwin   =subwin;
   m_x        =x;
   m_y        =y;
   m_x_size   =161;
   m_y_size   =158;
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating an element
   if(!CreateArea())
      return(false);
   if(!CreateMonthDecArrow())
      return(false);
   if(!CreateMonthIncArrow())
      return(false);
   if(!CreateMonthsList())
      return(false);
   if(!CreateYearsSpinEdit())
      return(false);
   if(!CreateDaysWeek())
      return(false);
   if(!CreateSeparateLine())
      return(false);
   if(!CreateDaysMonth())
      return(false);
   if(!CreateButtonToday())
      return(false);
//--- Update calendar
   UpdateCalendar();
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the common area of the calendar                          |
//+------------------------------------------------------------------+
bool CCalendar::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_calendar_bg_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y();
//--- Margins from the edge
   m_area.XGap(x-m_wnd.X());
   m_area.YGap(y-m_wnd.Y());
//--- Set the object
   if(!m_area.Create(m_chart_id,name,m_subwin,x,y,m_x_size,m_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_border_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create left month switch                                         |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\LeftTransp_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\LeftTransp_blue.bmp"
//---
bool CCalendar::CreateMonthDecArrow(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_calendar_left_arrow_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X();
   int y =CElement::Y()+5;
//--- If the icon for the arrow is not specified, then set the default one
   if(m_left_arrow_file_on=="")
      m_left_arrow_file_on="Images\\EasyAndFastGUI\\Controls\\LeftTransp_blue.bmp";
   if(m_left_arrow_file_off=="")
      m_left_arrow_file_off="Images\\EasyAndFastGUI\\Controls\\LeftTransp_black.bmp";
//--- Set the object
   if(!m_month_dec.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_month_dec.BmpFileOn("::"+m_left_arrow_file_on);
   m_month_dec.BmpFileOff("::"+m_left_arrow_file_off);
   m_month_dec.Corner(m_corner);
   m_month_dec.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_month_dec.Selectable(false);
   m_month_dec.Z_Order(m_button_zorder);
   m_month_dec.Tooltip("\n");
//--- Store the size (in the object)
   m_month_dec.XSize(m_month_dec.X_Size());
   m_month_dec.YSize(m_month_dec.Y_Size());
//--- Store coordinates
   m_month_dec.X(x);
   m_month_dec.Y(y);
//--- Margins from the edge
   m_month_dec.XGap(x-m_wnd.X());
   m_month_dec.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_month_dec);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create right month switch                                        |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_blue.bmp"
//---
bool CCalendar::CreateMonthIncArrow(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_calendar_right_arrow_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+CElement::XSize()-17;
   int y =CElement::Y()+5;
//--- If the icon for the arrow is not specified, then set the default one
   if(m_right_arrow_file_on=="")
      m_right_arrow_file_on="Images\\EasyAndFastGUI\\Controls\\RArrow_blue.bmp";
   if(m_right_arrow_file_off=="")
      m_right_arrow_file_off="Images\\EasyAndFastGUI\\Controls\\RArrow_black.bmp";
//--- Set the object
   if(!m_month_inc.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_month_inc.BmpFileOn("::"+m_right_arrow_file_on);
   m_month_inc.BmpFileOff("::"+m_right_arrow_file_off);
   m_month_inc.Corner(m_corner);
   m_month_inc.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_month_inc.Selectable(false);
   m_month_inc.Z_Order(m_button_zorder);
   m_month_inc.Tooltip("\n");
//--- Store the size (in the object)
   m_month_inc.XSize(m_month_inc.X_Size());
   m_month_inc.YSize(m_month_inc.Y_Size());
//--- Store coordinates
   m_month_inc.X(x);
   m_month_inc.Y(y);
//--- Margins from the edge
   m_month_inc.XGap(x-m_wnd.X());
   m_month_inc.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_month_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create combobox with months                                      |
//+------------------------------------------------------------------+
bool CCalendar::CreateMonthsList(void)
  {
//--- Store the window pointer
   m_months.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X()+17;
   int y=CElement::Y()+4;
//--- Set properties before creation
   m_months.XSize(75);
   m_months.YSize(19);
   m_months.LabelText("");
   m_months.ButtonXSize(75);
   m_months.ButtonYSize(19);
   m_months.AreaColor(m_area_color);
   m_months.ButtonBackColor(C'230,230,230');
   m_months.ButtonBackColorHover(C'193,218,255');
   m_months.ButtonBorderColor(C'200,200,200');
   m_months.ButtonBorderColorHover(C'85,170,255');
   m_months.ItemsTotal(12);
   m_months.VisibleItemsTotal(5);
   m_months.IsDropdown(CElement::IsDropdown());
//--- Get the list view pointer
   CListView *lv=m_months.GetListViewPointer();
//--- Set the list view properties
   lv.LightsHover(true);
//--- Store the values to the list (names of months)
   for(int i=0; i<12; i++)
      m_months.ValueToList(i,m_date.MonthName(i+1));
//--- Select the current month in the list
    m_months.SelectedItemByIndex(m_date.mon-1);
//--- Create control
   if(!m_months.CreateComboBox(m_chart_id,m_subwin,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create year edit box                                             |
//+------------------------------------------------------------------+
bool CCalendar::CreateYearsSpinEdit(void)
  {
//--- Store the window pointer
   m_years.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X()+96;
   int y=CElement::Y()+4;
//--- Set properties before creation
   m_years.XSize(50);
   m_years.YSize(18);
   m_years.EditXSize(35);
   m_years.EditYSize(19);
   m_years.MaxValue(2099);
   m_years.MinValue(1970);
   m_years.StepValue(1);
   m_years.SetDigits(0);
   m_years.SetValue(m_date.year);
   m_years.AreaColor(m_area_color);
   m_years.LabelColor(clrBlack);
   m_years.LabelColorLocked(clrBlack);
   m_years.EditColorLocked(clrWhite);
   m_years.EditTextColor(clrBlack);
   m_years.EditTextColorLocked(clrBlack);
   m_years.EditBorderColor(clrSilver);
   m_years.EditBorderColorLocked(clrSilver);
   m_years.IsDropdown(CElement::IsDropdown());
//--- Create control
   if(!m_years.CreateSpinEdit(m_chart_id,m_subwin,"",x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create names for the days of the week                            |
//+------------------------------------------------------------------+
bool CCalendar::CreateDaysWeek(void)
  {
//--- Coordinates
   int x =CElement::X()+9;
   int y =CElement::Y()+26;
//--- Size
   int x_size =21;
   int y_size =16;
//--- Counter for days of the week (for the objects array)
   int w=0;
//--- Set the objects displaying the abbreviated names for the days of the week
   for(int i=1; i<7; i++,w++)
     {
      //--- Forming the object name
      string name=CElement::ProgramName()+"_calendar_days_week_"+string(w)+"__"+(string)CElement::Id();
      //--- Calculation of the X coordinate
      x=(w>0)? x+x_size : x;
      //--- Set the object
      if(!m_days_week[w].Create(m_chart_id,name,m_subwin,x,y,x_size,y_size))
         return(false);
      //--- Setting the properties
      m_days_week[w].Description(m_date.ShortDayName(i));
      m_days_week[w].TextAlign(ALIGN_CENTER);
      m_days_week[w].Font(FONT);
      m_days_week[w].FontSize(FONT_SIZE);
      m_days_week[w].Color(m_item_text_color);
      m_days_week[w].BorderColor(m_area_color);
      m_days_week[w].BackColor(m_area_color);
      m_days_week[w].Corner(m_corner);
      m_days_week[w].Anchor(m_anchor);
      m_days_week[w].Selectable(false);
      m_days_week[w].Z_Order(m_zorder);
      m_days_week[w].ReadOnly(true);
      m_days_week[w].Tooltip("\n");
      //--- Set properties before creation
      m_days_week[w].XSize(x_size);
      m_days_week[w].YSize(y_size);
      //--- Margins from the edge of the panel
      m_days_week[w].XGap(x-m_wnd.X());
      m_days_week[w].YGap(y-m_wnd.Y());
      //--- Store the object pointer
      CElement::AddToArray(m_days_week[w]);
      //--- If there was a reset, leave
      if(i==0)
         break;
      //--- Reset, if passed all days of the week
      if(i>=6)
         i=-1;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a separation line below the names of days of the week     |
//+------------------------------------------------------------------+
bool CCalendar::CreateSeparateLine(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_calendar_separate_line_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+7;
   int y =CElement::Y()+42;
//--- Size
   int x_size =147;
   int y_size =1;
//--- Create interface control
   if(!m_sep_line.Create(m_chart_id,name,m_subwin,x,y,x_size,y_size))
      return(false);
//--- Setting the properties
   m_sep_line.BorderType(BORDER_FLAT);
   m_sep_line.Color(clrLightGray);
//--- Margins from the edge of the panel
   m_sep_line.XGap(x-m_wnd.X());
   m_sep_line.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_sep_line);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create table of days of the month                                |
//+------------------------------------------------------------------+
bool CCalendar::CreateDaysMonth(void)
  {
//--- Coordinates
   int x =CElement::X()+9;
   int y =CElement::Y()+44;
//--- Size
   int x_size =21;
   int y_size =15;
//--- Counter of days
   int i=0;
//--- Set the objects of table of calendar days
   for(int r=0; r<6; r++)
     {
      //--- Calculating the Y coordinate
      y=(r>0)? y+y_size : y;
      //---
      for(int c=0; c<7; c++)
        {
         //--- Forming the object name
         string name=CElement::ProgramName()+"_calendar_day_"+string(c)+"_"+string(r)+"__"+(string)CElement::Id();
         //--- Calculation of the X coordinate
         x=(c==0)? CElement::X()+9 : x+x_size;
         //--- Set the object
         if(!m_days[i].Create(m_chart_id,name,m_subwin,x,y,x_size,y_size))
            return(false);
         //--- Setting the properties
         m_days[i].Description(string(i));
         m_days[i].TextAlign(ALIGN_RIGHT);
         m_days[i].Font(FONT);
         m_days[i].FontSize(8);
         m_days[i].Color(clrBlack);
         m_days[i].BorderColor(m_area_color);
         m_days[i].BackColor(m_area_color);
         m_days[i].Corner(m_corner);
         m_days[i].Anchor(m_anchor);
         m_days[i].Selectable(false);
         m_days[i].Z_Order(m_button_zorder);
         m_days[i].ReadOnly(true);
         m_days[i].Tooltip("\n");
         //--- Set properties before creation
         m_days[i].XSize(x_size);
         m_days[i].YSize(y_size);
         //--- Margins from the edge of the panel
         m_days[i].XGap(x-m_wnd.X());
         m_days[i].YGap(y-m_wnd.Y());
         //--- Store the object pointer
         CElement::AddToArray(m_days[i]);
         i++;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button to go to the current date                          |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp"
//---
bool CCalendar::CreateButtonToday(void)
  {
//--- Store the window pointer
   m_button_today.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X()+20;
   int y=CElement::Y()+134;
//--- Set properties before creation
   m_button_today.TwoState(false);
   m_button_today.ButtonXSize(123);
   m_button_today.ButtonYSize(21);
   m_button_today.LabelXGap(30);
   m_button_today.LabelYGap(5);
   m_button_today.LabelColor(m_item_text_color);
   m_button_today.LabelColorOff(m_item_text_color);
   m_button_today.LabelColorHover(C'0,102,250');
   m_button_today.LabelColorPressed(C'0,102,250');
   m_button_today.BackColor(m_area_color);
   m_button_today.BackColorOff(m_area_color);
   m_button_today.BackColorHover(m_area_color);
   m_button_today.BackColorPressed(m_area_color);
   m_button_today.BorderColor(m_area_color);
   m_button_today.BorderColorOff(m_area_color);
   m_button_today.IconFileOn("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
   m_button_today.IconFileOff("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
   m_button_today.IsDropdown(CElement::IsDropdown());
//--- Create control
   if(!m_button_today.CreateIconButton(m_chart_id,m_subwin,"Today: "+::TimeToString(::TimeLocal(),TIME_DATE),x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Selection of a new date                                          |
//+------------------------------------------------------------------+
void CCalendar::SelectedDate(const datetime date)
  {
//--- Store date in the structure and field of the class
   m_date.DateTime(date);
//--- Display last changes in the calendar
   UpdateCalendar();
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CCalendar::ChangeObjectsColor(void)
  {
   m_month_dec.State(m_month_dec.MouseFocus());
   m_month_inc.State(m_month_inc.MouseFocus());
  }
//+------------------------------------------------------------------+
//| Change the color of objects in the calendar table                |
//| when hovering over the cursor                                    |
//+------------------------------------------------------------------+
void CCalendar::ChangeObjectsColor(const int x,const int y)
  {
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   OffsetFirstDayOfMonth();
//--- Iterate over the table's items in the loop
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
     {
      //--- If a month of the item matches with a current month and 
      //    the item date matches the selected date
      if(m_temp_date.mon==m_date.mon &&
         m_temp_date.day==m_date.day)
        {
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //--- If a year/month/day of the item matches with a year/month/day of a current date (today)
      if(m_temp_date.year==m_today.year && 
         m_temp_date.mon==m_today.mon &&
         m_temp_date.day==m_today.day)
        {
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //--- If the mouse cursor is over this item
      if(x>m_days[i].X() && x<m_days[i].X2() &&
         y>m_days[i].Y() && y<m_days[i].Y2())
        {
         m_days[i].BackColor(m_item_back_color_hover);
         m_days[i].BorderColor(m_item_border_color_hover);
         m_days[i].Color((m_temp_date.mon==m_date.mon)? m_item_text_color_hover : m_item_text_color_off);
        }
      else
        {
         m_days[i].BackColor(m_item_back_color);
         m_days[i].BorderColor(m_item_border_color);
         m_days[i].Color((m_temp_date.mon==m_date.mon)? m_item_text_color : m_item_text_color_off);
        }
      //--- Proceed to the next item of the table
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Display last changes in the calendar                             |
//+------------------------------------------------------------------+
void CCalendar::UpdateCalendar(void)
  {
//--- Display changes in the calendar table
   SetCalendar();
//--- Highlight the current date and the user selected date
   HighlightDate();
//--- Set the year in the entry field
   m_years.ChangeValue(m_date.year);
//--- Set the month in the combo box list
    m_months.SelectedItemByIndex(m_date.mon-1);
  }
//+------------------------------------------------------------------+
//| Update current date                                              |
//+------------------------------------------------------------------+
void CCalendar::UpdateCurrentDate(void)
  {
//--- Counter
   static int count=0;
//--- Exit if was less than a second
   if(count<1000)
     {
      count+=TIMER_STEP_MSC;
      return;
     }
//--- Zero the counter
   count=0;
//--- Obtain current (local) time
   MqlDateTime local_time;
   ::TimeToStruct(::TimeLocal(),local_time);
//--- If a new day has begun
   if(local_time.day!=m_today.day)
     {
      //--- Update date in the calendar
      m_today.DateTime(::TimeLocal());
      m_button_today.Object(2).Description(::TimeToString(m_today.DateTime()));
      //--- Display last changes in the calendar
      UpdateCalendar();
      return;
     }
//--- Update date in the calendar
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CCalendar::Moving(const int x,const int y)
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
   m_month_dec.X(x+m_month_dec.XGap());
   m_month_dec.Y(y+m_month_dec.YGap());
   m_month_inc.X(x+m_month_inc.XGap());
   m_month_inc.Y(y+m_month_inc.YGap());
   m_sep_line.X(x+m_sep_line.XGap());
   m_sep_line.Y(y+m_sep_line.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_month_dec.X_Distance(m_month_dec.X());
   m_month_dec.Y_Distance(m_month_dec.Y());
   m_month_inc.X_Distance(m_month_inc.X());
   m_month_inc.Y_Distance(m_month_inc.Y());
   m_sep_line.X_Distance(m_sep_line.X());
   m_sep_line.Y_Distance(m_sep_line.Y());
//--- Objects of names of the days of the week
   for(int i=0; i<7; i++)
     {
      //--- Storing coordinates in the fields of the objects
      m_days_week[i].X(x+m_days_week[i].XGap());
      m_days_week[i].Y(y+m_days_week[i].YGap());
      //--- Updating coordinates of graphical objects
      m_days_week[i].X_Distance(m_days_week[i].X());
      m_days_week[i].Y_Distance(m_days_week[i].Y());
     }
//--- Objects of calendar days
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
     {
      //--- Storing coordinates in the fields of the objects
      m_days[i].X(x+m_days[i].XGap());
      m_days[i].Y(y+m_days[i].YGap());
      //--- Updating coordinates of graphical objects
      m_days[i].X_Distance(m_days[i].X());
      m_days[i].Y_Distance(m_days[i].Y());
     }
  }
//+------------------------------------------------------------------+
//| Show the calendar                                                |
//+------------------------------------------------------------------+
void CCalendar::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- Show all elements
   m_years.Show();
   m_months.Show();
   m_button_today.Show();
//--- State of visibility
   CElement::IsVisible(true);
//--- If this is a drop-down calendar, then send a command to zero the priorities on clicking other controls
   if(CElement::IsDropdown())
      ::EventChartCustom(m_chart_id,ON_ZERO_PRIORITIES,CElement::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Hide calendar                                                    |
//+------------------------------------------------------------------+
void CCalendar::Hide(void)
  {
//--- Leave, if the element is already hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- Hide all controls
   m_years.Hide();
   m_months.Hide();
   m_button_today.Hide();
//---
   m_years.SpinEditState(true);
   m_button_today.ButtonState(true);
//--- State of visibility
   CElement::IsVisible(false);
//--- Send command to restore the priorities on clicking objects
   ::EventChartCustom(m_chart_id,ON_SET_PRIORITIES,0,0.0,"");
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CCalendar::Reset(void)
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
void CCalendar::Delete(void)
  {
//--- Delete calendar objects
   m_area.Delete();
   m_month_dec.Delete();
   m_month_inc.Delete();
//---
   for(int i=0; i<7; i++)
      m_days_week[i].Delete();
//---
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
      m_days[i].Delete();
//---
   m_sep_line.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CCalendar::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_month_dec.Z_Order(m_button_zorder);
   m_month_inc.Z_Order(m_button_zorder);
//---
   for(int i=0; i<7; i++)
      m_days_week[i].Z_Order(m_zorder);
//---
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
      m_days[i].Z_Order(m_button_zorder);
//---
   m_button_today.SetZorders();
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CCalendar::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_month_dec.Z_Order(0);
   m_month_inc.Z_Order(0);
//---
   for(int i=0; i<7; i++)
      m_days_week[i].Z_Order(0);
//---
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
      m_days[i].Z_Order(0);
//---
   m_button_today.ResetZorders();
  }
//+------------------------------------------------------------------+
//| Click the arrow to the left. Go to a previous a month.              |          |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthDec(const string clicked_object)
  {
//--- Exit if it has a different object name
   if(::StringFind(clicked_object,m_month_dec.Name(),0)<0)
      return(false);
//--- If the current year in the calendar equals a minimum indicated and
//    current month is "January"
   if(m_date.year==m_years.MinValue() && m_date.mon==1)
     {
      //--- Highlight value and exit
      m_years.HighlightLimit();
      return(true);
     }
//--- Set the state to On
   m_month_dec.State(true);
//--- Go to a previous month
   m_date.MonDec();
//--- Set first day of a month
   m_date.day=1;
//--- Reset time
   ResetTime();
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Click the arrow to the left. Go to the next month.           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthInc(const string clicked_object)
  {
//--- Exit if it has a different object name
   if(::StringFind(clicked_object,m_month_inc.Name(),0)<0)
      return(false);
//--- If current year in the calendar equals a specified maximum and
//    the current month is "December"
   if(m_date.year==m_years.MaxValue() && m_date.mon==12)
     {
      //--- Highlight value and exit
      m_years.HighlightLimit();
      return(true);
     }
//--- Set the state to On
   m_month_inc.State(true);
//--- Go to the next month
   m_date.MonInc();
//--- Set first day of a month
   m_date.day=1;
//--- Reset time
   ResetTime();
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle month selection in the list                               |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthList(const long id)
  {
//--- Leave, if control identifiers do not match
   if(id!=CElement::Id())
      return(false);
//--- Unblock elements
   m_years.SpinEditState(true);
   m_button_today.ButtonState(true);
//--- Obtain selected month in a list
   int month=m_months.GetListViewPointer().SelectedItemIndex()+1;
   m_date.Mon(month);
//--- Correcting the selected day by the number of days in a month
   CorrectingSelectedDay();
//--- Reset time
   ResetTime();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle value entry to the year edit box                          |
//+------------------------------------------------------------------+
bool CCalendar::OnEndEnterYear(const string edited_object)
  {
//--- Leave, if the object name is different
   if(::StringFind(edited_object,m_years.Object(2).Name(),0)<0)
      return(false);
//--- Exit if the value hasn't changed
   string value=m_years.Object(2).Description();
   if(m_date.year==(int)value)
      return(false);
//--- Correct value in case of going beyond the set restrictions
   if((int)value<m_years.MinValue())
     {
      value=(string)int(m_years.MinValue());
      //--- Highlight value
      m_years.HighlightLimit();
     }
   if((int)value>m_years.MaxValue())
     {
      value=(string)int(m_years.MaxValue());
      //--- Highlight value
      m_years.HighlightLimit();
     }
//--- Define the number of days in a current month
   string year  =value;
   string month =string(m_date.mon);
   string day   =string(1);
   m_temp_date.DateTime(::StringToTime(year+"."+month+"."+day));
//--- If value of a selected day exceeds the number of days in a month,
//    set current number of days in a month as a selected day
   if(m_date.day>m_temp_date.DaysInMonth())
      m_date.day=m_temp_date.DaysInMonth();
//--- Set a date in the structure
   m_date.DateTime(::StringToTime(year+"."+month+"."+string(m_date.day)));
//--- Display changes in the table of the calendar
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on the button to go to a following year          |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearInc(const long id)
  {
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Leave, if control identifiers do not match
   if(id!=CElement::Id())
      return(false);
//--- If a year is below the maximum specified, then to increase value by one
   if(m_date.year<m_years.MaxValue())
      m_date.YearInc();
//--- Correcting the selected day by the number of days in a month
   CorrectingSelectedDay();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on the button to go to a previous year           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearDec(const long id)
  {
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Leave, if control identifiers do not match
   if(id!=CElement::Id())
      return(false);
//--- If the year is greater than the minimum specified, reduce the value by one
   if(m_date.year>m_years.MinValue())
      m_date.YearDec();
//--- Correcting the selected day by the number of days in a month  
   CorrectingSelectedDay();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on a day of a month of the calendar              |
//+------------------------------------------------------------------+
bool CCalendar::OnClickDayOfMonth(const string clicked_object)
  {
//--- Exit if clicking wasn't at the day of the calendar
   if(::StringFind(clicked_object,CElement::ProgramName()+"_calendar_day_",0)<0)
      return(false);
//--- Get the identifier and index from the object name
   int id=CElement::IdFromObjectName(clicked_object);
//--- Leave, if the identifier does not match
   if(id!=CElement::Id())
      return(false);
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   OffsetFirstDayOfMonth();
//--- Iterate over the table's items in the loop
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
     {
      //--- If the date of the current item is lower than a minimum set in the system
      if(m_temp_date.DateTime()<datetime(D'01.01.1970'))
        {
         //--- If this is the object that we have clicked on
         if(m_days[i].Name()==clicked_object)
           {
            //--- Highlight value and exit
            m_years.HighlightLimit();
            return(false);
           }
         //--- Move to the next date
         m_temp_date.DayInc();
         continue;
        }
      //--- If this is the object that we have clicked on
      if(m_days[i].Name()==clicked_object)
        {
         //--- Store date
         m_date.DateTime(m_temp_date.DateTime());
         //--- Display last changes in the calendar
         UpdateCalendar();
         break;
        }
      //--- Move to the next date
      m_temp_date.DayInc();
      //--- Check exit beyond the maximum set in the system
      if(m_temp_date.year>m_years.MaxValue())
        {
         //--- Highlight value and exit
         m_years.HighlightLimit();
         return(false);
        }
     }
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking the button to go to a current date               |
//+------------------------------------------------------------------+
bool CCalendar::OnClickTodayButton(const long id)
  {
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Leave, if control identifiers do not match
   if(id!=CElement::Id())
      return(false);
//--- Set the current date
   m_date.DateTime(::TimeLocal());
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Determine the first day of a month                               |
//+------------------------------------------------------------------+
void CCalendar::CorrectingSelectedDay(void)
  {
//--- Set the current number of days in a month, it the selected day value is higher
   if(m_date.day>m_date.DaysInMonth())
      m_date.day=m_date.DaysInMonth();
  }
//+------------------------------------------------------------------+
//| Define the difference from the first item of the calendar's tab  |
//| until the item of the first day of the current month             |
//+------------------------------------------------------------------+
int CCalendar::OffsetFirstDayOfMonth(void)
  {
//--- Get the date of the first day of the selected year and month in a string
   string date=string(m_date.year)+"."+string(m_date.mon)+"."+string(1);
//--- Set this date in the structure for calculations
   m_temp_date.DateTime(::StringToTime(date));
//--- If the result of deducting 1 from the current number of the day of the week exceeds or equals 0,
//    return result, otherwise — return 6
   int diff=(m_temp_date.day_of_week-1>=0) ? m_temp_date.day_of_week-1 : 6;
//--- Store date that is in the first item of the table
   m_temp_date.DayDec(diff);
   return(diff);
  }
//+------------------------------------------------------------------+
//| Setting calendar values                                          |
//+------------------------------------------------------------------+
void CCalendar::SetCalendar(void)
  {
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   int diff=OffsetFirstDayOfMonth();
//--- Iterate over all items of the calendar table in the loop
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
     {
      //--- Setting day in the current item of the table
      m_days[i].Description(string(m_temp_date.day));
      //--- Move to the next date
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Fast switching the calendar                                      |
//+------------------------------------------------------------------+
void CCalendar::FastSwitching(void)
  {
//--- Leave, if the focus is not on the control
   if(!CElement::MouseFocus())
      return;
//--- Leave, if the form is blocked and identifiers do not match
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
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
      //--- If the left arrow is pressed
      if(m_month_dec.State())
        {
         //--- If the current year in the calendar exceeds/equals minimum specified
         if(m_date.year>=m_years.MinValue())
           {
            //--- If a current year in the calendar already equals a specified minimum and
            //    current month is "January"
            if(m_date.year==m_years.MinValue() && m_date.mon==1)
              {
               //--- Highlight value and exit
               m_years.HighlightLimit();
               return;
              }
            //--- Proceed to a next month (downward)
            m_date.MonDec();
            //--- Set first day of a month
            m_date.day=1;
           }
        }
      //--- If the right arrow is pressed
      else if(m_month_inc.State())
        {
         //--- If a current year in the calendar is below/equal to a specified maximum
         if(m_date.year<=m_years.MaxValue())
           {
            //--- If a current year in the calendar already equals a specified maximum and
            //    the current month is "December"
            if(m_date.year==m_years.MaxValue() && m_date.mon==12)
              {
               //--- Highlight value and exit
               m_years.HighlightLimit();
               return;
              }
            //--- Go to the following month (upward)
            m_date.MonInc();
            //--- Set first day of a month
            m_date.day=1;
           }
        }
      //--- If the increment button of the year entry field is pressed
      else if(m_years.StateInc())
        {
         //--- If below maximum specified year,
         //    go to the next year (upward)
         if(m_date.year<m_years.MaxValue())
            m_date.YearInc();
         else
           {
            //--- Highlight value and exit
            m_years.HighlightLimit();
            return;
           }
        }
      //--- If the field decrement button is pressed
      else if(m_years.StateDec())
        {
         //--- If a minimum specified year is exceeded,
         //    go to a following year (downward)
         if(m_date.year>m_years.MinValue())
            m_date.YearDec();
         else
           {
            //--- Highlight value and exit
            m_years.HighlightLimit();
            return;
           }
        }
      else
         return;
      //--- Display last changes in the calendar
      UpdateCalendar();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElement::Id(),m_date.DateTime(),"");
     }
  }
//+------------------------------------------------------------------+
//| Highlight the current date and the user selected date            |
//+------------------------------------------------------------------+
void CCalendar::HighlightDate(void)
  {
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   OffsetFirstDayOfMonth();
//--- Iterate over the table's items in the loop
   int items_total=::ArraySize(m_days);
   for(int i=0; i<items_total; i++)
     {
      //--- If a month of the item matches with a current month and 
      //    the item date matches the selected date
      if(m_temp_date.mon==m_date.mon &&
         m_temp_date.day==m_date.day)
        {
         m_days[i].Color(m_item_text_color);
         m_days[i].BackColor(m_item_back_color_selected);
         m_days[i].BorderColor(m_item_border_color_selected);
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //--- If this is a current date (today)
      if(m_temp_date.year==m_today.year && 
         m_temp_date.mon==m_today.mon &&
         m_temp_date.day==m_today.day)
        {
         m_days[i].BackColor(m_item_back_color);
         m_days[i].BorderColor(m_item_text_color_hover);
         m_days[i].Color(m_item_text_color_hover);
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //---
      m_days[i].BackColor(m_item_back_color);
      m_days[i].BorderColor(m_item_border_color);
      m_days[i].Color((m_temp_date.mon==m_date.mon)? m_item_text_color : m_item_text_color_off);
      //--- Proceed to the next item of the table
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Reset time to midnight                                           |
//+------------------------------------------------------------------+
void CCalendar::ResetTime(void)
  {
   m_date.hour =0;
   m_date.min  =0;
   m_date.sec  =0;
  }
//+------------------------------------------------------------------+
