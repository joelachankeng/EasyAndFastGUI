//+------------------------------------------------------------------+
//|                                                        Table.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
#include "Scrolls.mqh"
//+------------------------------------------------------------------+
//| Class for creating an edit box table                             |
//+------------------------------------------------------------------+
class CTable : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a table
   CRectLabel        m_area;
   CScrollV          m_scrollv;
   CScrollH          m_scrollh;
   //--- Array of objects for the visible part of the table
   struct TEdits
     {
      CEdit             m_rows[];
     };
   TEdits            m_columns[];
   //--- Array of table values and properties
   struct TOptions
     {
      string            m_vrows[];
      ENUM_ALIGN_MODE   m_text_align[];
      color             m_text_color[];
      color             m_cell_color[];
     };
   TOptions          m_vcolumns[];
   //--- The number of columns and rows (total and of visible part) of the table
   int               m_rows_total;
   int               m_columns_total;
   int               m_visible_rows_total;
   int               m_visible_columns_total;
   //--- Height of table rows
   int               m_row_y_size;
   //--- (1) Color of the background and (2) background frame of the table
   color             m_area_color;
   color             m_area_border_color;
   //--- Grid color
   color             m_grid_color;
   //--- Header background color
   color             m_headers_color;
   //--- Header text color
   color             m_headers_text_color;
   //--- Color of cells in different states
   color             m_cell_color;
   color             m_cell_color_hover;
   //--- Default color of cell texts
   color             m_cell_text_color;
   //--- Color of (1) the background and (2) selected row text
   color             m_selected_row_color;
   color             m_selected_row_text_color;
   //--- (1) Index and (2) text of the selected row
   int               m_selected_item;
   string            m_selected_item_text;
   //--- Editable table mode
   bool              m_read_only;
   //--- Mode of highlighting rows when hovered
   bool              m_lights_hover;
   //--- Selectable row mode
   bool              m_selectable_row;
   //--- Fixation mode of the first row
   bool              m_fix_first_row;
   //--- Fixation mode of the first column
   bool              m_fix_first_column;
   //--- Default text alignment mode in edit boxes
   ENUM_ALIGN_MODE   m_align_mode;
   //--- Priorities of the left mouse button press
   int               m_zorder;
   int               m_cell_zorder;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CTable(void);
                    ~CTable(void);
   //--- Methods for creating table
   bool              CreateTable(const long chart_id,const int subwin,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateCells(void);
   bool              CreateCanvasCells(void);
   bool              CreateScrollV(void);
   bool              CreateScrollH(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) returns pointers to scrollbars
   void              WindowPointer(CWindow &object)                    { m_wnd=::GetPointer(object);      }
   CScrollV         *GetScrollVPointer(void)                           { return(::GetPointer(m_scrollv)); }
   CScrollH         *GetScrollHPointer(void)                           { return(::GetPointer(m_scrollh)); }
   //--- Color of the (1) background and (2) frame of the table
   void              AreaColor(const color clr)                        { m_area_color=clr;                }
   void              BorderColor(const color clr)                      { m_area_border_color=clr;         }
   //--- (1) Get and (2) set the fixation mode of the first row
   bool              FixFirstRow(void)                           const { return(m_fix_first_row);         }
   void              FixFirstRow(const bool flag)                      { m_fix_first_row=flag;            }
   //--- (1) Get and (2) set the fixation mode of the first column
   bool              FixFirstColumn(void)                        const { return(m_fix_first_column);      }
   void              FixFirstColumn(const bool flag)                   { m_fix_first_column=flag;         }
   //--- Color of the (1) header background, (2) header text and (3) table grid
   void              HeadersColor(const color clr)                     { m_headers_color=clr;             }
   void              HeadersTextColor(const color clr)                 { m_headers_text_color=clr;        }
   void              GridColor(const color clr)                        { m_grid_color=clr;                }
   //--- Size of the rows along the Y axis
   void              RowYSize(const int y_size)                        { m_row_y_size=y_size;             }
   void              CellColor(const color clr)                        { m_cell_color=clr;                }
   void              CellColorHover(const color clr)                   { m_cell_color_hover=clr;          }
   //--- (1) "Read only", (2) row highlighting when hovered, (3) selectable row modes
   void              ReadOnly(const bool flag)                         { m_read_only=flag;                }
   void              LightsHover(const bool flag)                      { m_lights_hover=flag;             }
   void              SelectableRow(const bool flag)                    { m_selectable_row=flag;           }
   //--- Returns the total number of (1) rows and (2) columns, (3) state of the scrollbar
   int               RowsTotal(void)                             const { return(m_rows_total);            }
   int               ColumnsTotal(void)                          const { return(m_columns_total);         }
   //--- Returns the number of (1) rows and (2) columns of the visible part of the table
   int               VisibleRowsTotal(void)                      const { return(m_visible_rows_total);    }
   int               VisibleColumnsTotal(void)                   const { return(m_visible_columns_total); }
   //--- Returns the (1) index and (2) text of the selected row in the table, (3) text alignment mode in the cells
   int               SelectedItem(void)                          const { return(m_selected_item);         }
   string            SelectedItemText(void)                      const { return(m_selected_item_text);    }
   void              TextAlign(const ENUM_ALIGN_MODE align_mode)       { m_align_mode=align_mode;         }

   //--- Set the (1) size of the table and (2) size of its visible part
   void              TableSize(const int columns_total,const int rows_total);
   void              VisibleTableSize(const int visible_columns_total,const int visible_rows_total);
   //--- Set (1) the text alignment mode, (2) text color, (3) cell background color
   void              TextAlign(const int column_index,const int row_index,const ENUM_ALIGN_MODE mode);
   void              TextColor(const int column_index,const int row_index,const color clr);
   void              CellColor(const int column_index,const int row_index,const color clr);
   //--- Set the value to the specified table cell
   void              SetValue(const int column_index,const int row_index,const string value);
   //--- Get the value from the specified table cell
   string            GetValue(const int column_index,const int row_index);
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
   virtual void      ResetColors(void);
   //---
private:
   //--- Handling the pressing on the table row
   bool              OnClickTableRow(const string clicked_object);
   //--- Handling entering the value in the table cell
   bool              OnEndEditCell(const string edited_object);
   //--- Retrieve column index from the object name
   int               ColumnIndexFromObjectName(const string object_name);
   //--- Retrieve row index from the object name
   int               RowIndexFromObjectName(const string object_name);
   //--- Highlight the selected row
   void              HighlightSelectedItem(void);
   //--- Change the table row color when hovered
   void              RowColorByHover(const int x,const int y);
   //--- Fast forward the table data
   void              FastSwitching(void);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTable::CTable(void) : m_row_y_size(18),
                       m_fix_first_row(false),
                       m_fix_first_column(false),
                       m_read_only(true),
                       m_lights_hover(false),
                       m_selectable_row(false),
                       m_align_mode(ALIGN_LEFT),
                       m_rows_total(2),
                       m_columns_total(1),
                       m_visible_rows_total(2),
                       m_visible_columns_total(1),
                       m_selected_item(WRONG_VALUE),
                       m_selected_item_text(""),
                       m_headers_color(C'103,116,141'),
                       m_headers_text_color(clrWhite),
                       m_area_color(clrLightGray),
                       m_area_border_color(C'240,240,240'),
                       m_grid_color(clrLightGray),
                       m_cell_color(clrWhite),
                       m_cell_color_hover(C'240,240,240'),
                       m_cell_text_color(clrBlack),
                       m_selected_row_color(C'51,153,255'),
                       m_selected_row_text_color(clrWhite)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder      =1;
   m_cell_zorder =2;
//--- Set the size of the table and its visible part
   TableSize(m_columns_total,m_rows_total);
   VisibleTableSize(m_visible_columns_total,m_visible_rows_total);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTable::~CTable(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CTable::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- If the scrollbar is active
      if(m_scrollv.ScrollBarControl(m_mouse.X(),m_mouse.Y(),m_mouse.LeftButtonState()) ||
         m_scrollh.ScrollBarControl(m_mouse.X(),m_mouse.Y(),m_mouse.LeftButtonState()))
         //--- Shift the table
         UpdateTable();
      //--- Highlight the selected row
      HighlightSelectedItem();
      //--- Change the table row color when hovered
      RowColorByHover(m_mouse.X(),m_mouse.Y());
      return;
     }
//--- Handling the pressing on objects
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Leave, if the form is blocked
      if(m_wnd.IsLocked())
         return;
      //--- If table row is pressed
      if(OnClickTableRow(sparam))
        {
         //--- Highlight the selected row
         HighlightSelectedItem();
         return;
        }
      //--- If the scrollbar button was pressed
      if(m_scrollv.OnClickScrollInc(sparam) || m_scrollv.OnClickScrollDec(sparam) ||
         m_scrollh.OnClickScrollInc(sparam) || m_scrollh.OnClickScrollDec(sparam))
        {
         //--- Update table data with consideration of the recent changes
         UpdateTable();
         //--- Highlight the selected row
         HighlightSelectedItem();
         return;
        }
      return;
     }
//--- Handling the value change in edit event
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      OnEndEditCell(sparam);
      //--- Reset table colors
      ResetColors();
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTable::OnEventTimer(void)
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
//| Create edit box table                                            |
//+------------------------------------------------------------------+
bool CTable::CreateTable(const long chart_id,const int subwin,const int x,const int y)
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
   if(!CreateCells())
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
bool CTable::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_table_area_"+(string)CElement::Id();
//--- If there is a horizontal scrollbar, adjust the table size along the Y axis
   m_y_size=(m_columns_total>m_visible_columns_total) ? m_y_size+m_scrollh.ScrollWidth()-1 : m_y_size;
//--- Creating the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_border_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_zorder);
   m_area.Tooltip("\n");
//--- Margins from the edge
   m_area.XGap(m_x-m_wnd.X());
   m_area.YGap(m_y-m_wnd.Y());
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
//| Create the grid of table cells                                   |
//+------------------------------------------------------------------+
bool CTable::CreateCells(void)
  {
//--- Coordinates and width of the table cells
   int x =CElement::X()+1;
   int y =0;
   int w =0;
//--- Check for presence of a vertical scrollbar
   bool is_scrollv=m_rows_total>m_visible_rows_total;
//--- Calculation of column widths. 
//    Width depends on the number of visible columns and presence of a vertical scrollbar.
   if(m_visible_columns_total==1)
      w=(is_scrollv) ? m_x_size-m_scrollv.ScrollWidth() : m_x_size-2;
   else
      w=(is_scrollv) ?(m_x_size-m_scrollv.ScrollWidth())/m_visible_columns_total : m_x_size/m_visible_columns_total+1;
//--- Columns
   for(int c=0; c<m_visible_columns_total && c<m_columns_total; c++)
     {
      //--- Calculation of the X coordinate
      x=(c>0) ? x+w-1 : CElement::X()+1;
      //--- Adjust the width of the last column
      if(c+1>=m_visible_columns_total)
         w=(is_scrollv) ? CElement::X2()-x-m_scrollv.ScrollWidth() : CElement::X2()-x-1;
      //--- Rows
      for(int r=0; r<m_visible_rows_total && r<m_rows_total; r++)
        {
         //--- Forming the object name
         string name=CElement::ProgramName()+"_table_edit_"+(string)c+"_"+(string)r+"__"+(string)CElement::Id();
         //--- Calculating the Y coordinate
         y=(r>0) ? y+m_row_y_size-1 : CElement::Y()+1;
         //--- Creating the object
         if(!m_columns[c].m_rows[r].Create(m_chart_id,name,m_subwin,x,y,w,m_row_y_size))
            return(false);
         //--- Setting the properties
         m_columns[c].m_rows[r].Description("");
         m_columns[c].m_rows[r].TextAlign(m_align_mode);
         m_columns[c].m_rows[r].Font(FONT);
         m_columns[c].m_rows[r].FontSize(FONT_SIZE);
         m_columns[c].m_rows[r].Color(m_cell_text_color);
         m_columns[c].m_rows[r].BackColor(m_cell_color);
         m_columns[c].m_rows[r].BorderColor(m_grid_color);
         m_columns[c].m_rows[r].Corner(m_corner);
         m_columns[c].m_rows[r].Anchor(m_anchor);
         m_columns[c].m_rows[r].Selectable(false);
         m_columns[c].m_rows[r].Z_Order(m_cell_zorder);
         m_columns[c].m_rows[r].ReadOnly(m_read_only);
         m_columns[c].m_rows[r].Tooltip("\n");
         //--- Coordinates
         m_columns[c].m_rows[r].X(x);
         m_columns[c].m_rows[r].Y(y);
         //--- Margins from the edge of the panel
         m_columns[c].m_rows[r].XGap(x-m_wnd.X());
         m_columns[c].m_rows[r].YGap(y-m_wnd.Y());
         //--- Size
         m_columns[c].m_rows[r].XSize(w);
         m_columns[c].m_rows[r].YSize(m_row_y_size);
         //--- Store the object pointer
         CElement::AddToArray(m_columns[c].m_rows[r]);
        }
     }
//--- Highlight the selected row
   HighlightSelectedItem();
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a vertical scrollbar                                      |
//+------------------------------------------------------------------+
bool CTable::CreateScrollV(void)
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
//--- Set sizes
   m_scrollv.Id(CElement::Id());
   m_scrollv.IsDropdown(CElement::IsDropdown());
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize((m_columns_total>m_visible_columns_total)? CElement::YSize()-m_scrollv.ScrollWidth()+1 : CElement::YSize());
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(m_chart_id,m_subwin,x,y,m_rows_total,m_visible_rows_total))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a horizontal scrollbar                                    |
//+------------------------------------------------------------------+
bool CTable::CreateScrollH(void)
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
//--- Set sizes
   m_scrollh.Id(CElement::Id());
   m_scrollh.IsDropdown(CElement::IsDropdown());
   m_scrollh.XSize((m_rows_total>m_visible_rows_total)? m_area.XSize()-m_scrollh.ScrollWidth()+1 : m_area.XSize());
   m_scrollh.YSize(m_scrollh.ScrollWidth());
//--- Creating the scrollbar
   if(!m_scrollh.CreateScroll(m_chart_id,m_subwin,x,y,m_columns_total,m_visible_columns_total))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Fills the array by the specified indexes                         |
//+------------------------------------------------------------------+
void CTable::SetValue(const int column_index,const int row_index,const string value)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Store the value into the array
   m_vcolumns[column_index].m_vrows[row_index]=value;
  }
//+------------------------------------------------------------------+
//| Return value at the specified index                              | 
//+------------------------------------------------------------------+
string CTable::GetValue(const int column_index,const int row_index)
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
//| Fills the array of text alignment modes                          |
//+------------------------------------------------------------------+
void CTable::TextAlign(const int column_index,const int row_index,const ENUM_ALIGN_MODE mode)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Store the text color in the common array
   m_vcolumns[column_index].m_text_align[row_index]=mode;
  }
//+------------------------------------------------------------------+
//| Fill the text color array                                        |
//+------------------------------------------------------------------+
void CTable::TextColor(const int column_index,const int row_index,const color clr)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Store the text color in the common array
   m_vcolumns[column_index].m_text_color[row_index]=clr;
  }
//+------------------------------------------------------------------+
//| Fill the cell color array                                        |
//+------------------------------------------------------------------+
void CTable::CellColor(const int column_index,const int row_index,const color clr)
  {
//--- Checking for exceeding the column range
   int csize=::ArraySize(m_vcolumns);
   if(csize<1 || column_index<0 || column_index>=csize)
      return;
//--- Checking for exceeding the row range
   int rsize=::ArraySize(m_vcolumns[column_index].m_vrows);
   if(rsize<1 || row_index<0 || row_index>=rsize)
      return;
//--- Store the cell background color in the common array
   m_vcolumns[column_index].m_cell_color[row_index]=clr;
  }
//+------------------------------------------------------------------+
//| Set the size of the table                                        |
//+------------------------------------------------------------------+
void CTable::TableSize(const int columns_total,const int rows_total)
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
      ::ArrayResize(m_vcolumns[i].m_text_align,m_rows_total);
      ::ArrayResize(m_vcolumns[i].m_text_color,m_rows_total);
      ::ArrayResize(m_vcolumns[i].m_cell_color,m_rows_total);
      //--- Initialize the array of cell background colors with the default value
      ::ArrayInitialize(m_vcolumns[i].m_text_align,m_align_mode);
      ::ArrayInitialize(m_vcolumns[i].m_text_color,m_cell_text_color);
      ::ArrayInitialize(m_vcolumns[i].m_cell_color,m_cell_color);
     }
  }
//+------------------------------------------------------------------+
//| Set the size of the visible part of the table                    |
//+------------------------------------------------------------------+
void CTable::VisibleTableSize(const int visible_columns_total,const int visible_rows_total)
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
//| Update table data with consideration of the recent changes       |
//+------------------------------------------------------------------+
void CTable::UpdateTable(void)
  {
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
   int l=(m_fix_first_column) ? 1 : 0;
//--- Get the current positions of sliders of the vertical and horizontal scrollbars
   int h=m_scrollh.CurrentPos()+l;
   int v=m_scrollv.CurrentPos()+t;
//--- Set the properties for the first cell, if the header fixation modes are enabled
   if(m_fix_first_column && m_fix_first_row)
     {
      m_columns[0].m_rows[0].Description(m_vcolumns[0].m_vrows[0]);
      m_columns[0].m_rows[0].BackColor(m_headers_color);
      m_columns[0].m_rows[0].Color(m_headers_text_color);
      m_columns[0].m_rows[0].TextAlign(m_vcolumns[0].m_text_align[0]);
     }
//--- Shift of the headers in the left column
   if(m_fix_first_column)
     {
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         if(r>=t && r<m_rows_total)
           {
            //--- Value adjustment
            m_columns[0].m_rows[r].Description(m_vcolumns[0].m_vrows[v]);
            //--- Adjust the cell background color
            m_columns[0].m_rows[r].BackColor(m_headers_color);
            //--- Adjust the cell text color
            m_columns[0].m_rows[r].Color(m_headers_text_color);
            //--- Adjust the text alignment in cells
            m_columns[0].m_rows[r].TextAlign(m_vcolumns[0].m_text_align[v]);
           }
         //---
         v++;
        }
     }
//--- Shift of the headers in the top row
   if(m_fix_first_row)
     {
      //--- Columns
      for(int c=l; c<m_visible_columns_total; c++)
        {
         if(h>=l && h<m_columns_total)
           {
            //--- Value adjustment
            m_columns[c].m_rows[0].Description(m_vcolumns[h].m_vrows[0]);
            //--- Adjust the cell background color
            m_columns[c].m_rows[0].BackColor(m_headers_color);
            //--- Adjust the cell text color
            m_columns[c].m_rows[0].Color(m_headers_text_color);
            //--- Adjust the text alignment in cells
            m_columns[c].m_rows[0].TextAlign(m_vcolumns[h].m_text_align[0]);
           }
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
            //--- Value adjustment
            m_columns[c].m_rows[r].Description(m_vcolumns[h].m_vrows[v]);
            //--- Adjust the cell background color
            m_columns[c].m_rows[r].BackColor(m_vcolumns[h].m_cell_color[v]);
            //--- Adjust the cell text color
            m_columns[c].m_rows[r].Color(m_vcolumns[h].m_text_color[v]);
            //--- Adjust the text alignment in cells
            m_columns[c].m_rows[r].TextAlign(m_vcolumns[h].m_text_align[v]);
            v++;
           }
        }
      //---
      h++;
     }
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CTable::Moving(const int x,const int y)
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
void CTable::Show(void)
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
void CTable::Hide(void)
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
void CTable::Reset(void)
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
void CTable::Delete(void)
  {
//--- Delete graphical objects
   m_area.Delete();
   for(int c=0; c<m_visible_columns_total; c++)
     {
      for(int r=0; r<m_visible_rows_total; r++)
         m_columns[c].m_rows[r].Delete();
      //--- Emptying the control arrays
      ::ArrayFree(m_columns[c].m_rows);
     }
//--- Emptying the control arrays
   for(int c=0; c<m_columns_total; c++)
     {
      ::ArrayFree(m_vcolumns[c].m_vrows);
      ::ArrayFree(m_vcolumns[c].m_text_align);
      ::ArrayFree(m_vcolumns[c].m_text_color);
      ::ArrayFree(m_vcolumns[c].m_cell_color);
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
void CTable::SetZorders(void)
  {
   m_area.Z_Order(m_zorder);
   m_scrollv.SetZorders();
   m_scrollh.SetZorders();
//---
   for(int c=0; c<m_visible_columns_total; c++)
     {
      for(int r=0; r<m_visible_rows_total; r++)
         m_columns[c].m_rows[r].Z_Order(m_cell_zorder);
     }
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CTable::ResetZorders(void)
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
//| Reset the color of the element objects                           |
//+------------------------------------------------------------------+
void CTable::ResetColors(void)
  {
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
   int l=(m_fix_first_column) ? 1 : 0;
//--- Get the current position of slider of the horizontal scrollbar
   int h=m_scrollh.CurrentPos()+l;
//--- Columns
   for(int c=l; c<m_visible_columns_total; c++)
     {
      //--- Get the current position of slider of the vertical scrollbar
      int v=m_scrollv.CurrentPos()+t;
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         //--- Check to prevent exceeding the array range
         if(v>=t && v<m_rows_total)
           {
            //--- Skip if the selected item is reached and it is in "Read only" mode
            if(m_selected_item==v && m_read_only)
              {
               v++;
               continue;
              }
            //--- Adjust the cell background color
            m_columns[c].m_rows[r].BackColor(m_vcolumns[h].m_cell_color[v]);
            v++;
           }
        }
      //---
      h++;
     }
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the table row                           |
//+------------------------------------------------------------------+
bool CTable::OnClickTableRow(const string clicked_object)
  {
//--- Leave, if editable table mode is enabled
   if(!m_read_only)
      return(false);
//--- Leave, if the scrollbar is active
   if(m_scrollv.ScrollState() || m_scrollh.ScrollState())
      return(false);
//--- Leave, if the pressing was not on the table cell
   if(::StringFind(clicked_object,CElement::ProgramName()+"_table_edit_",0)<0)
      return(false);
//--- Get the identifier from the object name
   int id=CElement::IdFromObjectName(clicked_object);
//--- Leave, if the identifier does not match
   if(id!=CElement::Id())
      return(false);
//--- Search for the row index
   int row_index=0;
//--- To stop the cycle
   bool stop=false;
//--- Cell parameters (column_row_text)
   string cell_params="";
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
//--- Columns
   for(int c=0; c<m_visible_columns_total; c++)
     {
      //--- Get the current position of slider of the vertical scrollbar
      int v=m_scrollv.CurrentPos()+t;
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         //--- If the pressing was not on this cell
         if(m_columns[c].m_rows[r].Name()==clicked_object)
           {
            //--- If clicked on a selected item, deselect
            if(v==m_selected_item)
              {
               m_selected_item      =WRONG_VALUE;
               m_selected_item_text ="";
               cell_params          =string(c)+"_"+string(r)+"_"+m_columns[c].m_rows[r].Description();
               //--- Send a message about it
               ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElement::Id(),m_selected_item,cell_params);
               //--- Stop the cycle
               stop=true;
               break;
              }
            //--- Store the row index
            m_selected_item=row_index=v;
            //--- Store the cell row
            m_selected_item_text=m_columns[c].m_rows[r].Description();
            //--- Generate a string with the cell parameters
            cell_params=string(c)+"_"+string(r)+"_"+m_selected_item_text;
            //--- Stop the cycle
            stop=true;
            break;
           }
         //--- Increase the row counter
         if(v>=t && v<m_rows_total)
            v++;
        }
      //---
      if(stop)
         break;
     }
//--- Leave, if a header was pressed
   if(m_fix_first_row && row_index<1)
      return(false);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElement::Id(),m_selected_item,cell_params);
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of finishing editing a cell value                          |
//+------------------------------------------------------------------+
bool CTable::OnEndEditCell(const string edited_object)
  {
//--- Leave, if the editable table mode is disabled
   if(m_read_only)
      return(false);
//--- Leave, if the pressing was not on the table cell
   if(::StringFind(edited_object,CElement::ProgramName()+"_table_edit_",0)<0)
      return(false);
//--- Get the identifier from the object name
   int id=CElement::IdFromObjectName(edited_object);
//--- Leave, if the identifier does not match
   if(id!=CElement::Id())
      return(false);
//--- Get the column and row indexes of the cell
   int c =ColumnIndexFromObjectName(edited_object);
   int r =RowIndexFromObjectName(edited_object);
//--- Get the column and row indexes in the data array
   int vc =c+m_scrollh.CurrentPos();
   int vr =r+m_scrollv.CurrentPos();
//--- Adjust the row index, if a header was pressed
   if(m_fix_first_row && r==0)
      vr=0;
//--- Get the entered value
   string cell_text=m_columns[c].m_rows[r].Description();
//--- If the cell value has been changed
   if(cell_text!=m_vcolumns[vc].m_vrows[vr])
     {
      //--- Store the value in the array
      SetValue(vc,vr,cell_text);
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),0,string(vc)+"_"+string(vr)+"_"+cell_text);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Retrieve column index from the object name                       |
//+------------------------------------------------------------------+
int CTable::ColumnIndexFromObjectName(const string object_name)
  {
   ushort u_sep=0;
   string result[];
   int    array_size=0;
//--- Get the code of the separator
   u_sep=::StringGetCharacter("_",0);
//--- Split the string
   ::StringSplit(object_name,u_sep,result);
   array_size=::ArraySize(result)-1;
//--- Checking for exceeding the array range
   if(array_size-3<0)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Return the item index
   return((int)result[array_size-3]);
  }
//+------------------------------------------------------------------+
//| Retrieve row index from the object name                          |
//+------------------------------------------------------------------+
int CTable::RowIndexFromObjectName(const string object_name)
  {
   ushort u_sep=0;
   string result[];
   int    array_size=0;
//--- Get the code of the separator
   u_sep=::StringGetCharacter("_",0);
//--- Split the string
   ::StringSplit(object_name,u_sep,result);
   array_size=::ArraySize(result)-1;
//--- Checking for exceeding the array range
   if(array_size-2<0)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Return the item index
   return((int)result[array_size-2]);
  }
//+------------------------------------------------------------------+
//| Highlight the selected row                                       |
//+------------------------------------------------------------------+
void CTable::HighlightSelectedItem(void)
  {
//--- Leave, if one of the modes ("Read only", "Selectable row") is disabled
   if(!m_read_only || !m_selectable_row)
      return;
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
   int l=(m_fix_first_column) ? 1 : 0;
//--- Get the current position of slider of the horizontal scrollbar
   int h=m_scrollh.CurrentPos()+l;
//--- Columns
   for(int c=l; c<m_visible_columns_total; c++)
     {
      //--- Get the current position of slider of the vertical scrollbar
      int v=m_scrollv.CurrentPos()+t;
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         //--- Shift of the table data
         if(v>=t && v<m_rows_total)
           {
            //--- Adjustment with consideration of the selected row
            color back_color=(m_selected_item==v) ? m_selected_row_color : m_vcolumns[h].m_cell_color[v];
            color text_color=(m_selected_item==v) ? m_selected_row_text_color : m_vcolumns[h].m_text_color[v];
            //--- Adjust the text and background color of the cell
            m_columns[c].m_rows[r].Color(text_color);
            m_columns[c].m_rows[r].BackColor(back_color);
            v++;
           }
        }
      //---
      h++;
     }
  }
//+------------------------------------------------------------------+
//| Change the table row color when hovered                          |
//+------------------------------------------------------------------+
void CTable::RowColorByHover(const int x,const int y)
  {
//--- Leave, if row highlighting when hovered is disabled of if the form is blocked
   if(!m_lights_hover || !m_read_only || m_wnd.IsLocked())
      return;
//--- Leave, if the scrollbar is in the process of moving
   if(m_scrollv.ScrollState() || m_scrollh.ScrollState())
      return;
//--- Shift by one index, if the fixed header mode is enabled
   int t=(m_fix_first_row) ? 1 : 0;
   int l=(m_fix_first_column) ? 1 : 0;
//--- Get the current position of slider of the horizontal scrollbar
   int h=m_scrollh.CurrentPos()+l;
//--- Columns
   for(int c=l; c<m_visible_columns_total; c++)
     {
      //--- Get the current position of slider of the vertical scrollbar
      int v=m_scrollv.CurrentPos()+t;
      //--- Rows
      for(int r=t; r<m_visible_rows_total; r++)
        {
         //--- Check to prevent exceeding the array range
         if(v>=t && v<m_rows_total)
           {
            //--- Skip, if in the "Read only" mode, row selecting is enabled and the selected item is reached
            if(m_selected_item==v && m_read_only && m_selectable_row)
              {
               v++;
               continue;
              }
            //--- Highlight the row, if it is hovered
            if(x>m_columns[0].m_rows[r].X() && x<m_columns[m_visible_columns_total-1].m_rows[r].X2() &&
               y>m_columns[c].m_rows[r].Y() && y<m_columns[c].m_rows[r].Y2())
              {
               m_columns[c].m_rows[r].BackColor(m_cell_color_hover);
              }
            //--- Restore the default color, if the cursor is outside the area of this row
            else
              {
               if(v>=t && v<m_rows_total)
                  m_columns[c].m_rows[r].BackColor(m_vcolumns[h].m_cell_color[v]);
              }
            //---
            v++;
           }
        }
      //---
      h++;
     }
  }
//+------------------------------------------------------------------+
//| Fast forward the table data                                      |
//+------------------------------------------------------------------+
void CTable::FastSwitching(void)
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
      //--- Update data and properties
      UpdateTable();
      //--- Highlighting the item
      HighlightSelectedItem();
     }
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTable::ChangeWidthByRightWindowSide(void)
  {
//--- Coordinates and width of the columns
   int x=0;
   int w=0;
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
//--- Check for presence of a vertical scrollbar
   bool is_scrollv=m_rows_total>m_visible_rows_total;
//--- Calculation of column widths. 
//    Width depends on the number of visible columns and presence of a vertical scrollbar.
   if(m_visible_columns_total==1)
      w=(is_scrollv) ? m_x_size-m_scrollv.ScrollWidth() : m_x_size-2;
   else
      w=(is_scrollv) ?(m_x_size-m_scrollv.ScrollWidth())/m_visible_columns_total : m_x_size/m_visible_columns_total+1;
//--- Columns
   for(int c=0; c<m_visible_columns_total && c<m_columns_total; c++)
     {
      //--- Calculation of the X coordinate
      x=(c>0) ? x+w-1 : CElement::X()+1;
      //--- Adjust the width of the last column
      if(c+1>=m_visible_columns_total)
         w=(is_scrollv) ? CElement::X2()-x-m_scrollv.ScrollWidth() : CElement::X2()-x-1;
      //--- Rows
      for(int r=0; r<m_visible_rows_total && r<m_rows_total; r++)
        {
         //--- Coordinates
         m_columns[c].m_rows[r].X(x);
         m_columns[c].m_rows[r].X_Distance(x);
         //--- Margins from the edge of the panel
         m_columns[c].m_rows[r].XGap(x-m_wnd.X());
         //--- Size
         m_columns[c].m_rows[r].XSize(w);
         m_columns[c].m_rows[r].X_Size(w);
        }
     }
//--- Update the position of objects
   Moving(m_wnd.X(),m_wnd.Y());
  }
//+------------------------------------------------------------------+
