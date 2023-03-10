//+------------------------------------------------------------------+
//|                                                  LabelsTable.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "Scrolls.mqh"
//+------------------------------------------------------------------+
//| Class for creating a text label table                            |
//+------------------------------------------------------------------+
class CLabelsTable : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a table
   CRectLabel        m_area;
   CScrollV          m_scrollv;
   CScrollH          m_scrollh;
   //--- Array of objects for the visible part of the table
   struct LTLabels
     {
      CLabel            m_rows[];
     };
   LTLabels          m_columns[];
   //--- Array of table values and properties
   struct LTOptions
     {
      string            m_vrows[];
      color             m_colors[];
     };
   LTOptions         m_vcolumns[];
   //--- The number of columns and rows (total and of visible part) of the table
   int               m_rows_total;
   int               m_columns_total;
   int               m_visible_rows_total;
   int               m_visible_columns_total;
   //--- Row height
   int               m_row_y_size;
   //--- Table background color
   color             m_area_color;
   //--- Default color of table text
   color             m_text_color;
   //--- Distance between the anchor point of the first column and the left edge of the control
   int               m_x_offset;
   //--- Distance between the anchor points of the columns
   int               m_column_x_offset;
   //--- Fixation mode of the first row
   bool              m_fix_first_row;
   //--- Fixation mode of the first column
   bool              m_fix_first_column;
   //--- Priorities of the left mouse button press
   int               m_zorder;
   int               m_area_zorder;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CLabelsTable(void);
                    ~CLabelsTable(void);
   //--- Methods for creating table
   bool              CreateLabelsTable(const long chart_id,const int subwin,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateLabels(void);
   bool              CreateScrollV(void);
   bool              CreateScrollH(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) returns pointers to scrollbars
   void              WindowPointer(CWindow &object)               { m_wnd=::GetPointer(object);      }
   CScrollV         *GetScrollVPointer(void)                      { return(::GetPointer(m_scrollv)); }
   CScrollH         *GetScrollHPointer(void)                      { return(::GetPointer(m_scrollh)); }
   //--- Returns the total number of (1) rows and (2) columns
   int               RowsTotal(void)                        const { return(m_rows_total);            }
   int               ColumnsTotal(void)                     const { return(m_columns_total);         }
   //--- Returns the number of (1) rows and (2) columns of the visible part of the table
   int               VisibleRowsTotal(void)                 const { return(m_visible_rows_total);    }
   int               VisibleColumnsTotal(void)              const { return(m_visible_columns_total); }
   //--- (1) Background color, (2) text color
   void              AreaColor(const color clr)                   { m_area_color=clr;                }
   void              TextColor(const color clr)                   { m_text_color=clr;                }
   //--- (1) Row height, (2) set the distance between the anchor point of the first column and the left edge of the table,
   //    (3) set the distance between anchor points of columns
   void              RowYSize(const int y_size)                   { m_row_y_size=y_size;             }
   void              XOffset(const int x_offset)                  { m_x_offset=x_offset;             }
   void              ColumnXOffset(const int x_offset)            { m_column_x_offset=x_offset;      }
   //--- (1) Get and (2) set the fixation mode of the first row
   bool              FixFirstRow(void)                      const { return(m_fix_first_row);         }
   void              FixFirstRow(const bool flag)                 { m_fix_first_row=flag;            }
   //--- (1) Get and (2) set the fixation mode of the first column
   bool              FixFirstColumn(void)                   const { return(m_fix_first_column);      }
   void              FixFirstColumn(const bool flag)              { m_fix_first_column=flag;         }

   //--- Set the (1) size of the table and (2) size of its visible part 
   void              TableSize(const int columns_total,const int rows_total);
   void              VisibleTableSize(const int visible_columns_total,const int visible_rows_total);
   //--- Set the value to the specified table cell
   void              SetValue(const int column_index,const int row_index,const string value);
   //--- Get the value from the specified table cell
   string            GetValue(const int column_index,const int row_index);
   //--- Change the text color in the specified table cell
   void              TextColor(const int column_index,const int row_index,const color clr);
   //--- Update table data with consideration of the recent changes
   void              UpdateTable(void);

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
   //--- Fast forward of the list view
   void              FastSwitching(void);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLabelsTable::CLabelsTable(void) : m_fix_first_row(false),
                                   m_fix_first_column(false),
                                   m_row_y_size(18),
                                   m_x_offset(30),
                                   m_column_x_offset(60),
                                   m_area_color(clrWhiteSmoke),
                                   m_text_color(clrBlack),
                                   m_rows_total(2),
                                   m_columns_total(1),
                                   m_visible_rows_total(2),
                                   m_visible_columns_total(1)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder      =0;
   m_area_zorder =1;
//--- Set the size of the table and its visible part
   TableSize(m_columns_total,m_rows_total);
   VisibleTableSize(m_visible_columns_total,m_visible_rows_total);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLabelsTable::~CLabelsTable(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CLabelsTable::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- Checking the focus over the table
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      //--- Move the list if the management of the slider is enabled
      if(m_scrollv.ScrollBarControl(m_mouse.X(),m_mouse.Y(),m_mouse.LeftButtonState()) ||
         m_scrollh.ScrollBarControl(m_mouse.X(),m_mouse.Y(),m_mouse.LeftButtonState()))
         UpdateTable();
      //---
      return;
     }
//--- Handling the pressing on objects
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- If the pressing was on a button of the table scrollbars
      if(m_scrollv.OnClickScrollInc(sparam) || m_scrollv.OnClickScrollDec(sparam) ||
         m_scrollh.OnClickScrollInc(sparam) || m_scrollh.OnClickScrollDec(sparam))
         //--- Shift the table relative to the scrollbar
         UpdateTable();
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CLabelsTable::OnEventTimer(void)
  {
//--- If this is a drop-down element
   if(CElement::IsDropdown())
      FastSwitching();
//--- If this is not a drop-down element, take current availability of the form into consideration
   else
     {
      //--- Track the fast forward of the table only if the form is not blocked
      if(!m_wnd.IsLocked())
         FastSwitching();
     }
  }
//+------------------------------------------------------------------+
//| Create text label table                                          |
//+------------------------------------------------------------------+
bool CLabelsTable::CreateLabelsTable(const long chart_id,const int subwin,const int x,const int y)
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
   m_x_size   =(m_x_size<1)? m_wnd.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =m_row_y_size*m_visible_rows_total-(m_visible_rows_total-1)+2;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Create the table
   if(!CreateArea())
      return(false);
   if(!CreateLabels())
      return(false);
   if(!CreateScrollV())
      return(false);
   if(!CreateScrollH())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the table background                                      |
//+------------------------------------------------------------------+
bool CLabelsTable::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_labelstable_area_"+(string)CElement::Id();
//--- Margins from the edge
   m_area.XGap(CElement::X()-m_wnd.X());
   m_area.YGap(CElement::Y()-m_wnd.Y());
//--- If there is a horizontal scrollbar, adjust the table size along the Y axis
   m_y_size=(m_columns_total>m_visible_columns_total) ? m_y_size+m_scrollh.ScrollWidth()-1 : m_y_size;
//--- Creating the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Store the size
   m_area.XSize(CElement::XSize());
   m_area.YSize(CElement::YSize());
//--- Store coordinates
   m_area.X(CElement::X());
   m_area.Y(CElement::Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create an array of text labels                                   |
//+------------------------------------------------------------------+
bool CLabelsTable::CreateLabels(void)
  {
//--- Coordinates and offset
   int x      =CElement::X();
   int y      =0;
   int offset =0;
//--- Columns
   for(int c=0; c<m_visible_columns_total; c++)
     {
      //--- Calculation of the table offset
      offset=(c>0) ? m_column_x_offset : m_x_offset;
      //--- Calculation of the X coordinate
      x=x+offset;
      //--- Rows
      for(int r=0; r<m_visible_rows_total; r++)
        {
         //--- Forming the object name
         string name=CElement::ProgramName()+"_labelstable_label_"+(string)c+"_"+(string)r+"__"+(string)CElement::Id();
         //--- Calculating the Y coordinate
         y=(r>0) ? y+m_row_y_size-1 : CElement::Y()+10;
         //--- Creating the object
         if(!m_columns[c].m_rows[r].Create(m_chart_id,name,m_subwin,x,y))
            return(false);
         //--- Setting the properties
         m_columns[c].m_rows[r].Description(m_vcolumns[c].m_vrows[r]);
         m_columns[c].m_rows[r].Font(FONT);
         m_columns[c].m_rows[r].FontSize(FONT_SIZE);
         m_columns[c].m_rows[r].Color(m_text_color);
         m_columns[c].m_rows[r].Corner(m_corner);
         m_columns[c].m_rows[r].Anchor(ANCHOR_CENTER);
         m_columns[c].m_rows[r].Selectable(false);
         m_columns[c].m_rows[r].Z_Order(m_zorder);
         m_columns[c].m_rows[r].Tooltip("\n");
         //--- Margins from the edge of the form
         m_columns[c].m_rows[r].XGap(x-m_wnd.X());
         m_columns[c].m_rows[r].YGap(y-m_wnd.Y());
         //--- Coordinates
         m_columns[c].m_rows[r].X(x);
         m_columns[c].m_rows[r].Y(y);
         //--- Store the object pointer
         CElement::AddToArray(m_columns[c].m_rows[r]);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a vertical scrollbar                                      |
//+------------------------------------------------------------------+
bool CLabelsTable::CreateScrollV(void)
  {
//--- If the total number of rows is greater than the visible part of the table,
//    set a vertical scrollbar
   if(m_rows_total<=m_visible_rows_total)
      return(true);
//--- Store the form pointer
   m_scrollv.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X2()-m_scrollv.ScrollWidth();
   int y=CElement::Y();
//--- set properties
   m_scrollv.Id(CElement::Id());
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(CElement::YSize()-m_scrollv.ScrollWidth()+1);
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(m_chart_id,m_subwin,x,y,m_rows_total,m_visible_rows_total))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a horizontal scrollbar                                    |
//+------------------------------------------------------------------+
bool CLabelsTable::CreateScrollH(void)
  {
//--- If the total number of columns is greater than the visible part of the table,
//    set a horizontal scrollbar
   if(m_columns_total<=m_visible_columns_total)
      return(true);
//--- Store the form pointer
   m_scrollh.WindowPointer(m_wnd);
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y2()-m_scrollh.ScrollWidth();
//--- set properties
   m_scrollh.Id(CElement::Id());
   m_scrollh.XSize(CElement::XSize()-m_scrollh.ScrollWidth()+1);
   m_scrollh.YSize(m_scrollh.ScrollWidth());
//--- Creating the scrollbar
   if(!m_scrollh.CreateScroll(m_chart_id,m_subwin,x,y,m_columns_total,m_visible_columns_total))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Set the size of the table                                        |
//+------------------------------------------------------------------+
void CLabelsTable::TableSize(const int columns_total,const int rows_total)
  {
//--- There must be at least one column
   m_columns_total=(columns_total<1) ? 1 : columns_total;
//--- There must be at least two rows
   m_rows_total=(rows_total<2) ? 2 : rows_total;
//--- Set the size of the columns array
   ::ArrayResize(m_vcolumns,m_columns_total);
//--- Set the size of the rows arrays
   for(int i=0; i<m_columns_total; i++)
     {
      ::ArrayResize(m_vcolumns[i].m_vrows,m_rows_total);
      ::ArrayResize(m_vcolumns[i].m_colors,m_rows_total);
      //--- Initialize the array of text colors with the default value
      ::ArrayInitialize(m_vcolumns[i].m_colors,m_text_color);
     }
  }
//+------------------------------------------------------------------+
//| Set the size of the visible part of the table                    |
//+------------------------------------------------------------------+
void CLabelsTable::VisibleTableSize(const int visible_columns_total,const int visible_rows_total)
  {
//--- There must be at least one column
   m_visible_columns_total=(visible_columns_total<1) ? 1 : visible_columns_total;
//--- There must be at least two rows
   m_visible_rows_total=(visible_rows_total<2) ? 2 : visible_rows_total;
//--- Set the size of the columns array
   ::ArrayResize(m_columns,m_visible_columns_total);
//--- Set the size of the rows arrays
   for(int i=0; i<m_visible_columns_total; i++)
      ::ArrayResize(m_columns[i].m_rows,m_visible_rows_total);
  }
//+------------------------------------------------------------------+
//| Set the value at the specified indexes                           |
//+------------------------------------------------------------------+
void CLabelsTable::SetValue(const int column_index,const int row_index,const string value)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Set the value
   m_vcolumns[column_index].m_vrows[row_index]=value;
  }
//+------------------------------------------------------------------+
//| Return value at the specified index                              |
//+------------------------------------------------------------------+
string CLabelsTable::GetValue(const int column_index,const int row_index)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return("");
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return("");
//--- Return the value
   return(m_vcolumns[column_index].m_vrows[row_index]);
  }
//+------------------------------------------------------------------+
//| Change color at the specified indexes                            |
//+------------------------------------------------------------------+
void CLabelsTable::TextColor(const int column_index,const int row_index,const color clr)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Set the color
   m_vcolumns[column_index].m_colors[row_index]=clr;
  }
//+------------------------------------------------------------------+
//| Update table data with consideration of the recent changes       |
//+------------------------------------------------------------------+
void CLabelsTable::UpdateTable(void)
  {
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
   int l=(m_fix_first_column) ? 1 : 0;
//--- Get the current positions of sliders of the vertical and horizontal scrollbars
   int h=m_scrollh.CurrentPos()+l;
   int v=m_scrollv.CurrentPos()+t;
//--- Shift of the headers in the left column
   if(m_fix_first_column)
     {
      m_columns[0].m_rows[0].Description(m_vcolumns[0].m_vrows[0]);
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         if(r>=t && r<m_rows_total)
            m_columns[0].m_rows[r].Description(m_vcolumns[0].m_vrows[v]);
         //---
         v++;
        }
     }
//--- Shift of the headers in the top row
   if(m_fix_first_row)
     {
      m_columns[0].m_rows[0].Description(m_vcolumns[0].m_vrows[0]);
      //--- Columns
      for(int c=l; c<m_visible_columns_total; c++)
        {
         if(h>=l && h<m_columns_total)
            m_columns[c].m_rows[0].Description(m_vcolumns[h].m_vrows[0]);
         //---
         h++;
        }
     }
//--- Get the current position of slider of the horizontal scrollbar
   h=m_scrollh.CurrentPos()+l;
//--- Columns
   for(int c=l; c<m_visible_columns_total; c++)
     {
      //--- Get the current position of slider of the vertical scrollbar
      v=m_scrollv.CurrentPos()+t;
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         //--- Shift of the table data
         if(v>=t && v<m_rows_total && h>=l && h<m_columns_total)
           {
            //--- Color adjustment
            m_columns[c].m_rows[r].Color(m_vcolumns[h].m_colors[v]);
            //--- Value adjustment
            m_columns[c].m_rows[r].Description(m_vcolumns[h].m_vrows[v]);
            v++;
           }
        }
      //---
      h++;
     }
  }
//+------------------------------------------------------------------+
//| Moving the element                                               |
//+------------------------------------------------------------------+
void CLabelsTable::Moving(const int x,const int y)
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
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
//--- Columns
   for(int c=0; c<m_visible_columns_total; c++)
     {
      //--- Rows
      for(int r=0; r<m_visible_rows_total; r++)
        {
         //--- Storing coordinates in the fields of the objects
         m_columns[c].m_rows[r].X(x+m_columns[c].m_rows[r].XGap());
         m_columns[c].m_rows[r].Y(y+m_columns[c].m_rows[r].YGap());
         //--- Updating coordinates of graphical objects
         m_columns[c].m_rows[r].X_Distance(m_columns[c].m_rows[r].X());
         m_columns[c].m_rows[r].Y_Distance(m_columns[c].m_rows[r].Y());
        }
     }
  }
//+------------------------------------------------------------------+
//| Shows the element                                                |
//+------------------------------------------------------------------+
void CLabelsTable::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- Show the scrollbars
   m_scrollv.Show();
   m_scrollh.Show();
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the element                                                |
//+------------------------------------------------------------------+
void CLabelsTable::Hide(void)
  {
//--- Leave, if the element is already hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- Hide the scrollbars
   m_scrollv.Hide();
   m_scrollh.Hide();
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CLabelsTable::Reset(void)
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
void CLabelsTable::Delete(void)
  {
//--- Delete graphical objects
   m_area.Delete();
   for(int c=0; c<m_visible_columns_total; c++)
     {
      for(int r=0; r<m_visible_rows_total; r++)
         m_columns[c].m_rows[r].Delete();
      //---
      ::ArrayFree(m_columns[c].m_rows);
     }
//--- Emptying the control arrays
   for(int c=0; c<m_columns_total; c++)
     {
      ::ArrayFree(m_vcolumns[c].m_vrows);
      ::ArrayFree(m_vcolumns[c].m_colors);
     }
//---
   ::ArrayFree(m_columns);
   ::ArrayFree(m_vcolumns);
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CLabelsTable::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_scrollv.SetZorders();
   m_scrollh.SetZorders();
//---
   for(int c=0; c<m_visible_columns_total; c++)
     {
      for(int r=0; r<m_visible_rows_total; r++)
         m_columns[c].m_rows[r].Z_Order(m_zorder);
     }
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CLabelsTable::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_scrollv.ResetZorders();
   m_scrollh.ResetZorders();
//---
   for(int c=0; c<m_visible_columns_total; c++)
     {
      for(int r=0; r<m_visible_rows_total; r++)
         m_columns[c].m_rows[r].Z_Order(0);
     }
  }
//+------------------------------------------------------------------+
//| Fast forward                                                     |
//+------------------------------------------------------------------+
void CLabelsTable::FastSwitching(void)
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
      //--- If scrolling left
      else if(m_scrollh.ScrollIncState())
         m_scrollh.OnClickScrollInc(m_scrollh.ScrollIncName());
      //--- If scrolling right
      else if(m_scrollh.ScrollDecState())
         m_scrollh.OnClickScrollDec(m_scrollh.ScrollDecName());
      //--- Moves the list
      UpdateTable();
     }
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CLabelsTable::ChangeWidthByRightWindowSide(void)
  {
//--- Coordinates
   int x=0;
//--- Size
   int x_size=0;
//--- Calculate and set the new size to the table background
   x_size=m_wnd.X2()-m_area.X()-m_auto_xresize_right_offset;
   CElement::XSize(x_size);
   m_area.XSize(x_size);
   m_area.X_Size(x_size);
//--- Calculate and set the new coordinate for the vertical scrollbar
   x=m_area.X2()-m_scrollv.ScrollWidth();
   m_scrollv.XDistance(x);
//--- Calculate and change the width of the horizontal scrollbar
   x_size=CElement::XSize()-m_scrollh.ScrollWidth()+1;
   m_scrollh.ChangeXSize(x_size);
//--- Update the position of objects
   Moving(m_wnd.X(),m_wnd.Y());
  }
//+------------------------------------------------------------------+
