//+------------------------------------------------------------------+
//|                                                    LineGraph.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a line chart                                  |
//+------------------------------------------------------------------+
class CLineGraph : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating the element
   CLineChartObject  m_line_chart;
   //--- Gradient colors
   color             m_bg_color;
   color             m_bg_color2;
   //--- Frame color
   color             m_border_color;
   //--- Grid color
   color             m_grid_color;
   //--- Text color
   color             m_text_color;
   //--- Number of decimal places
   int               m_digits;
   //---
public:
                     CLineGraph(void);
                    ~CLineGraph(void);
   //--- Methods for creating the control
   bool              CreateLineGraph(const long chart_id,const int subwin,const int x,const int y);
   //---
private:
   bool              CreateGraph(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) the number of decimal places, (3) the maximum number of data series
   void              WindowPointer(CWindow &object)    { m_wnd=::GetPointer(object);  }
   void              SetDigits(const int digits)       { m_digits=::fabs(digits);     }
   void              MaxData(const int total)          { m_line_chart.MaxData(total); }
   //--- Two colors for the gradient
   void              BackgroundColor(const color clr)  { m_bg_color=clr;              }
   void              BackgroundColor2(const color clr) { m_bg_color2=clr;             }
   //--- Colors of the (1) border, (2) grid and (3) text
   void              BorderColor(const color clr)      { m_border_color=clr;          }
   void              GridColor(const color clr)        { m_grid_color=clr;            }
   void              TextColor(const color clr)        { m_text_color=clr;            }
   //--- Setting parameters of the vertical scale
   void              VScaleParams(const double max,const double min,const int num_grid);
   //--- Add a series to the chart
   void              SeriesAdd(double &data[],const string descr,const color clr);
   //--- Update the series on the chart
   void              SeriesUpdate(const uint pos,const double &data[],const string descr,const color clr);
   //--- Delete the series from the chart
   void              SeriesDelete(const uint pos);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Timer
   virtual void      OnEventTimer(void) {}
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //---
private:
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLineGraph::CLineGraph(void) : m_digits(2),
                               m_bg_color(clrBlack),
                               m_bg_color2(C'0,80,95'),
                               m_border_color(clrDimGray),
                               m_grid_color(C'50,55,60'),
                               m_text_color(clrLightSlateGray)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLineGraph::~CLineGraph(void)
  {
  }
//+------------------------------------------------------------------+
//| Create a chart                                                   |
//+------------------------------------------------------------------+
bool CLineGraph::CreateLineGraph(const long chart_id,const int subwin,const int x,const int y)
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
//--- Creating an element
   if(!CreateGraph())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CLineGraph::CreateGraph(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_line_graph_"+(string)CElement::Id();
//--- Size
   m_x_size=(m_x_size<1)? m_wnd.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
//--- Creating the object
   if(!m_line_chart.CreateBitmapLabel(m_chart_id,m_subwin,name,m_x,m_y,m_x_size,m_y_size,COLOR_FORMAT_XRGB_NOALPHA))
      return(false);
//--- Attach the object to the terminal chart
   if(!m_line_chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_line_chart.FontSet(FONT,-80,FW_NORMAL);
   m_line_chart.ScaleDigits(m_digits);
   m_line_chart.ColorBackground(m_bg_color);
   m_line_chart.ColorBackground2(m_bg_color2);
   m_line_chart.ColorBorder(m_border_color);
   m_line_chart.ColorGrid(::ColorToARGB(m_grid_color));
   m_line_chart.ColorText(::ColorToARGB(m_text_color));
   m_line_chart.Tooltip("\n");
//--- Margins from the edge
   m_line_chart.XGap(CElement::X()-m_wnd.X());
   m_line_chart.YGap(CElement::Y()-m_wnd.Y());
//--- Store the sizes (in the group)
   m_line_chart.XSize(CElement::XSize());
   m_line_chart.YSize(CElement::YSize());
//--- Margins from the edge
   m_line_chart.XGap(CElement::X()-m_wnd.X());
   m_line_chart.YGap(CElement::Y()-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_line_chart);
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting parameters of the Y axis                                 |
//+------------------------------------------------------------------+
void CLineGraph::VScaleParams(const double max,const double min,const int num_grid)
  {
   m_line_chart.VScaleParams(max,min,num_grid);
  }
//+------------------------------------------------------------------+
//| Add series to the chart                                          |
//+------------------------------------------------------------------+
void CLineGraph::SeriesAdd(double &data[],const string descr,const color clr)
  {
   m_line_chart.SeriesAdd(data,descr,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Update series on the chart                                       |
//+------------------------------------------------------------------+
void CLineGraph::SeriesUpdate(const uint pos,const double &data[],const string descr,const color clr)
  {
   m_line_chart.SeriesUpdate(pos,data,descr,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Delete series from the chart                                     |
//+------------------------------------------------------------------+
void CLineGraph::SeriesDelete(const uint pos)
  {
   m_line_chart.SeriesDelete(pos);
  }
//+------------------------------------------------------------------+
//| Moving                                                           |
//+------------------------------------------------------------------+
void CLineGraph::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing coordinates in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_line_chart.X(x+m_line_chart.XGap());
   m_line_chart.Y(y+m_line_chart.YGap());
//--- Updating coordinates of graphical objects
   m_line_chart.X_Distance(m_line_chart.X());
   m_line_chart.Y_Distance(m_line_chart.Y());
  }
//+------------------------------------------------------------------+
//| Shows a menu item                                                |
//+------------------------------------------------------------------+
void CLineGraph::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   m_line_chart.Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CLineGraph::Hide(void)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   m_line_chart.Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CLineGraph::Reset(void)
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
void CLineGraph::Delete(void)
  {
   m_line_chart.DeleteAll();
   m_line_chart.Destroy();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CLineGraph::ChangeWidthByRightWindowSide(void)
  {
//--- Coordinates
   int x=0;
//--- Size
   int x_size=0;
//--- Calculate and set the new size
   x_size=m_wnd.X2()-m_line_chart.X()-m_auto_xresize_right_offset;
//--- Do not change the size, if it is less than the specified limit
   if(x_size<200)
      return;
//---
   m_line_chart.XSize(x_size);
   m_line_chart.Resize(x_size,m_line_chart.YSize());
//--- Update the position of objects
   Moving(m_wnd.X(),m_wnd.Y());
  }
//+------------------------------------------------------------------+
