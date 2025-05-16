//+------------------------------------------------------------------+
//|                                             OrderAssistant.mq4/5 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025 HaoWei"
#property version "1.0"
//#property icon "OrderAssistant.ico"
#property strict


#include <stderror.mqh>
#include <stdlib.mqh>
//#include <MT4Orders.mqh>
//#include <StdLibErr.mqh>






input double LotsInit=0.01;

input int SLInit=350;
input int TPInit=350;

input string Comments="OA";

input int ID=208;




long ChartIDLong;
double Scaling;
void OnInit(){
	
	TesterHideIndicators(true);
	
	ChartIDLong=ChartID();
	
	Scaling=TerminalInfoInteger(TERMINAL_SCREEN_DPI)/96.0;
	
	ChartSetInteger(ChartIDLong,CHART_FOREGROUND,false);
	ChartSetInteger(ChartIDLong,CHART_EVENT_MOUSE_MOVE,true);
	
	EventSetMillisecondTimer(8);
}


void OnDeinit(const int reason){
	
	Comment("");
	
	ObjectDelete(ChartIDLong,"BreakEven");
	
	ObjectDelete(ChartIDLong,"OpenSell");
	ObjectDelete(ChartIDLong,"OpenBuy");
	ObjectDelete(ChartIDLong,"CloseSell");
	ObjectDelete(ChartIDLong,"CloseBuy");
	
	ObjectDelete(ChartIDLong,"DailyReturn");
	
	ObjectDelete(ChartIDLong,"LotsSell");
	ObjectDelete(ChartIDLong,"ProfitSell");
	ObjectDelete(ChartIDLong,"LotsBuy");
	ObjectDelete(ChartIDLong,"ProfitBuy");
	
	EventKillTimer();
}


void DrawButton(string myName,string myText,string myFont,int myFontSize,color myColor,color myBackColor,int myX,int myY,int myWidth,int myHeight){
	
	ObjectCreate(ChartIDLong,myName,OBJ_BUTTON,0,0,0);
	ObjectSetString(ChartIDLong,myName,OBJPROP_TEXT,myText);
	
	ObjectSetString(ChartIDLong,myName,OBJPROP_FONT,myFont);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_FONTSIZE,myFontSize);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_COLOR,myColor);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BGCOLOR,myBackColor);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BORDER_COLOR,clrYellow);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_XDISTANCE,int (myX*Scaling));
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_YDISTANCE,int (myY*Scaling));
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_XSIZE,int (myWidth*Scaling));
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_YSIZE,int (myHeight*Scaling));
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_STATE,false);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_ZORDER,1);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTABLE,false);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTED,false);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_HIDDEN,true);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BACK,false);
}


void DrawLabel(string myName,string myText,string myFont,int myFontSize,color myColor,int myX,int myY){
	
	ObjectCreate(ChartIDLong,myName,OBJ_LABEL,0,0,0);
	ObjectSetString(ChartIDLong,myName,OBJPROP_TEXT,myText);
	
	ObjectSetString(ChartIDLong,myName,OBJPROP_FONT,myFont);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_FONTSIZE,myFontSize);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_COLOR,myColor);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_XDISTANCE,int (myX*Scaling));
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_YDISTANCE,int (myY*Scaling));
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTABLE,false);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTED,false);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_HIDDEN,true);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BACK,false);
}


void DrawHorizontalLine(string myName,string myText,double mPrice,color myColor,int myStyle,int myWidth){
	
	ObjectCreate(ChartIDLong,myName,OBJ_HLINE,0,TimeCurrent(),mPrice);
	ObjectSetString(ChartIDLong,myName,OBJPROP_TEXT,myText);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_COLOR,myColor);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_STYLE,myStyle);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_WIDTH,myWidth);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTABLE,false);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTED,false);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_HIDDEN,true);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BACK,false);
}


void DrawVerticalLine(string myName,datetime myTimeStamp,string myText,color myColor,int myStyle,int myWidth,bool myBack){
	
	ObjectCreate(ChartIDLong,myName,OBJ_VLINE,0,myTimeStamp,0);
	ObjectSetString(ChartIDLong,myName,OBJPROP_TEXT,myText);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_COLOR,myColor);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_STYLE,myStyle);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_WIDTH,myWidth);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTABLE,false);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_SELECTED,false);
	
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_HIDDEN,true);
	ObjectSetInteger(ChartIDLong,myName,OBJPROP_BACK,myBack);
}


void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam){
	
	if(id==CHARTEVENT_OBJECT_CLICK){
		
		if(sparam=="OpenSell"){
			PlaySound("tick.wav");
			ObjectSetInteger(ChartIDLong,"OpenSell",OBJPROP_STATE,false);
			BtnOpenSell(LotsInit,SLInit,TPInit,Comments,"BtnSell Open");
		}
		if(sparam=="OpenBuy"){
			PlaySound("tick.wav");
			ObjectSetInteger(ChartIDLong,"OpenBuy",OBJPROP_STATE,false);
			BtnOpenBuy(LotsInit,SLInit,TPInit,Comments,"BtnBuy Open");
		}
		if(sparam=="CloseSell"){
			PlaySound("tick.wav");
			ObjectSetInteger(ChartIDLong,"CloseSell",OBJPROP_STATE,false);
			BtnCloseSell("BtnSell Close");
		}
		if(sparam=="CloseBuy"){
			PlaySound("tick.wav");
			ObjectSetInteger(ChartIDLong,"CloseBuy",OBJPROP_STATE,false);
			BtnCloseBuy("BtnBuy Close");
		}
	}
}


MqlDateTime ErrorYMDHMS;
int ErrorInt;
void MarketError(){
	
	TimeToStruct(TimeCurrent(),ErrorYMDHMS);
	
	ResetLastError();
	ErrorInt=GetLastError();
	
	
	switch(ErrorInt){
		case ERR_COMMON_ERROR: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_COMMON_ERROR"); break;
		case ERR_INVALID_TRADE_PARAMETERS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_INVALID_TRADE_PARAMETERS"); break;
		case ERR_SERVER_BUSY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_SERVER_BUSY"); break;
		case ERR_OLD_VERSION: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_OLD_VERSION"); break;
		case ERR_NO_CONNECTION: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_NO_CONNECTION"); break;
		case ERR_NOT_ENOUGH_RIGHTS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_NOT_ENOUGH_RIGHTS"); break;
		case ERR_TOO_FREQUENT_REQUESTS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TOO_FREQUENT_REQUESTS"); break;
		case ERR_MALFUNCTIONAL_TRADE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_MALFUNCTIONAL_TRADE"); break;
		case ERR_ACCOUNT_DISABLED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_ACCOUNT_DISABLED"); break;
		case ERR_INVALID_ACCOUNT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_INVALID_ACCOUNT"); break;
		case ERR_TRADE_TIMEOUT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_TIMEOUT"); break;
		case ERR_INVALID_PRICE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_INVALID_PRICE"); break;
		case ERR_INVALID_STOPS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_INVALID_STOPS"); break;
		case ERR_INVALID_TRADE_VOLUME: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_INVALID_TRADE_VOLUME"); break;
		case ERR_MARKET_CLOSED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_MARKET_CLOSED"); break;
		case ERR_TRADE_DISABLED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_DISABLED"); break;
		case ERR_NOT_ENOUGH_MONEY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_NOT_ENOUGH_MONEY"); break;
		case ERR_PRICE_CHANGED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_PRICE_CHANGED"); break;
		case ERR_OFF_QUOTES: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_OFF_QUOTES"); break;
		case ERR_BROKER_BUSY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_BROKER_BUSY"); break;
		case ERR_REQUOTE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_REQUOTE"); break;
		case ERR_ORDER_LOCKED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_ORDER_LOCKED"); break;
		case ERR_LONG_POSITIONS_ONLY_ALLOWED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_LONG_POSITIONS_ONLY_ALLOWED"); break;
		case ERR_TOO_MANY_REQUESTS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TOO_MANY_REQUESTS"); break;
		case ERR_TRADE_MODIFY_DENIED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_MODIFY_DENIED"); break;
		case ERR_TRADE_CONTEXT_BUSY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_CONTEXT_BUSY"); break;
		case ERR_TRADE_EXPIRATION_DENIED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_EXPIRATION_DENIED"); break;
		case ERR_TRADE_TOO_MANY_ORDERS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_TOO_MANY_ORDERS"); break;
		case ERR_TRADE_HEDGE_PROHIBITED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_HEDGE_PROHIBITED"); break;
		case ERR_TRADE_PROHIBITED_BY_FIFO: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" ERR_TRADE_PROHIBITED_BY_FIFO"); break;
	}
	
	
	/*
	switch(ErrorInt){
		case TRADE_RETCODE_REQUOTE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_REQUOTE"); break;
		case TRADE_RETCODE_REJECT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_REJECT"); break;
		case TRADE_RETCODE_CANCEL: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_CANCEL"); break;
		case TRADE_RETCODE_DONE_PARTIAL: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_DONE_PARTIAL"); break;
		case TRADE_RETCODE_ERROR: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_ERROR"); break;
		case TRADE_RETCODE_TIMEOUT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_TIMEOUT"); break;
		case TRADE_RETCODE_INVALID: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID"); break;
		case TRADE_RETCODE_INVALID_VOLUME: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_VOLUME"); break;
		case TRADE_RETCODE_INVALID_PRICE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_PRICE"); break;
		case TRADE_RETCODE_INVALID_STOPS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_STOPS"); break;
		case TRADE_RETCODE_TRADE_DISABLED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_TRADE_DISABLED"); break;
		case TRADE_RETCODE_MARKET_CLOSED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_MARKET_CLOSED"); break;
		case TRADE_RETCODE_NO_MONEY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_NO_MONEY"); break;
		case TRADE_RETCODE_PRICE_CHANGED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_PRICE_CHANGED"); break;
		case TRADE_RETCODE_PRICE_OFF: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_PRICE_OFF"); break;
		case TRADE_RETCODE_INVALID_EXPIRATION: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_EXPIRATION"); break;
		case TRADE_RETCODE_ORDER_CHANGED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_ORDER_CHANGED"); break;
		case TRADE_RETCODE_TOO_MANY_REQUESTS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_TOO_MANY_REQUESTS"); break;
		case TRADE_RETCODE_NO_CHANGES: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_NO_CHANGES"); break;
		case TRADE_RETCODE_SERVER_DISABLES_AT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_SERVER_DISABLES_AT"); break;
		case TRADE_RETCODE_CLIENT_DISABLES_AT: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_CLIENT_DISABLES_AT"); break;
		case TRADE_RETCODE_LOCKED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_LOCKED"); break;
		case TRADE_RETCODE_FROZEN: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_FROZEN"); break;
		case TRADE_RETCODE_INVALID_FILL: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_FILL"); break;
		case TRADE_RETCODE_CONNECTION: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_CONNECTION"); break;
		case TRADE_RETCODE_ONLY_REAL: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_ONLY_REAL"); break;
		case TRADE_RETCODE_LIMIT_ORDERS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_LIMIT_ORDERS"); break;
		case TRADE_RETCODE_LIMIT_VOLUME: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_LIMIT_VOLUME"); break;
		case TRADE_RETCODE_INVALID_ORDER: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_ORDER"); break;
		case TRADE_RETCODE_POSITION_CLOSED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_POSITION_CLOSED"); break;
		case TRADE_RETCODE_INVALID_CLOSE_VOLUME: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_INVALID_CLOSE_VOLUME"); break;
		case TRADE_RETCODE_CLOSE_ORDER_EXIST: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_CLOSE_ORDER_EXIST"); break;
		case TRADE_RETCODE_LIMIT_POSITIONS: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_LIMIT_POSITIONS"); break;
		case TRADE_RETCODE_REJECT_CANCEL: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_REJECT_CANCEL"); break;
		case TRADE_RETCODE_LONG_ONLY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_LONG_ONLY"); break;
		case TRADE_RETCODE_SHORT_ONLY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_SHORT_ONLY"); break;
		case TRADE_RETCODE_CLOSE_ONLY: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_CLOSE_ONLY"); break;
		case TRADE_RETCODE_FIFO_CLOSE: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_FIFO_CLOSE"); break;
		case TRADE_RETCODE_HEDGE_PROHIBITED: Print(StringFormat("%02s",DoubleToString(ErrorYMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(ErrorYMDHMS.min,0))+" TRADE_RETCODE_HEDGE_PROHIBITED"); break;
	}
	*/
}


MqlDateTime YMDHMS;
datetime ExpertForbiddenTimeStamp;
bool ExpertForbiddenBool;
datetime ConnectingServerFailTimeStamp;
bool ConnectingServerFailBool;
datetime ConnectingServerPingTimeStamp;
bool ConnectingServerPingBool;
datetime TradeModeTimeStamp;
bool TradeModeBool;
void MarketSafe(){
	
	TimeToStruct(TimeCurrent(),YMDHMS);
	
	if(TimeLocal()>ExpertForbiddenTimeStamp+14400){
		ExpertForbiddenBool=false;
	}
	if(AccountInfoInteger(ACCOUNT_TRADE_EXPERT)==false && ExpertForbiddenBool==false){
		ExpertForbiddenBool=true;
		ExpertForbiddenTimeStamp=TimeLocal();
		Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Server Forbidden Expert Advisor");
	}
	
	if(TimeLocal()>ConnectingServerFailTimeStamp+300){
		ConnectingServerFailBool=false;
	}
	if(TerminalInfoInteger(TERMINAL_CONNECTED)==false && ConnectingServerFailBool==false){
		ConnectingServerFailBool=true;
		ConnectingServerFailTimeStamp=TimeLocal();
		Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Server Connecting Fail");
	}
	
	if(TimeLocal()>ConnectingServerPingTimeStamp+300){
		ConnectingServerPingBool=false;
	}
	if(TerminalInfoInteger(TERMINAL_CONNECTED)==true && TerminalInfoInteger(TERMINAL_PING_LAST)>=1000000 && ConnectingServerPingBool==false){
		ConnectingServerPingBool=true;
		ConnectingServerPingTimeStamp=TimeLocal();
		Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Server Ping > 1000 ms");
	}
	
	if(TimeLocal()>TradeModeTimeStamp+14400){
		TradeModeBool=false;
	}
	if(SymbolInfoInteger(Symbol(),SYMBOL_TRADE_MODE)!=SYMBOL_TRADE_MODE_FULL && TradeModeBool==false){
		TradeModeBool=true;
		TradeModeTimeStamp=TimeLocal();
		
		switch((int)SymbolInfoInteger(Symbol(),SYMBOL_TRADE_MODE)){
			case SYMBOL_TRADE_MODE_DISABLED:
				Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Trade Disabled");
				break;
			case SYMBOL_TRADE_MODE_LONGONLY:
				Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Trade LongOnly");
				break;
			case SYMBOL_TRADE_MODE_SHORTONLY:
				Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Trade ShortOnly");
				break;
			case SYMBOL_TRADE_MODE_CLOSEONLY:
				Print(StringFormat("%02s",DoubleToString(YMDHMS.hour,0))+":"+StringFormat("%02s",DoubleToString(YMDHMS.min,0))+"  Trade CloseOnly");
				break;
		}
	}
}


double ReturnBuy;
double ReturnSell;
double ReturnSum;
int HistoryCount;
void MarketHistory(){
	
	ReturnBuy=0;
	ReturnSell=0;
	
	for(HistoryCount=(OrdersHistoryTotal()-1);HistoryCount>=0;HistoryCount--){
		if(OrderSelect(HistoryCount,SELECT_BY_POS,MODE_HISTORY)==true){
			if(StringCompare(TimeToString(OrderCloseTime(),TIME_DATE),TimeToString(TimeCurrent(),TIME_DATE))==0){
				if(OrderMagicNumber()==ID && StringCompare(OrderSymbol(),Symbol())==0){
					if(OrderType()==OP_BUY){
						ReturnBuy+=(OrderProfit()+OrderCommission()+OrderSwap());
					}
					if(OrderType()==OP_SELL){
						ReturnSell+=(OrderProfit()+OrderCommission()+OrderSwap());
					}
				}
			}else{
				break;
			}
		}
	}
	
	ReturnSum=ReturnBuy+ReturnSell;
}


double LotsBuy;
double LotsSell;
double ProfitBuy;
double ProfitSell;
double ProfitSum;
int CurrentCount;
void MarketCurrent(){
	
	LotsBuy=0;
	LotsSell=0;
	ProfitBuy=0;
	ProfitSell=0;
	
	for(CurrentCount=(OrdersTotal()-1);CurrentCount>=0;CurrentCount--){
		if(OrderSelect(CurrentCount,SELECT_BY_POS,MODE_TRADES)==true){
			if(OrderMagicNumber()==ID && StringCompare(OrderSymbol(),Symbol())==0){
				if(OrderType()==OP_BUY){
					LotsBuy+=OrderLots();
					ProfitBuy+=(OrderProfit()+OrderCommission()+OrderSwap());
				}
				if(OrderType()==OP_SELL){
					LotsSell+=OrderLots();
					ProfitSell+=(OrderProfit()+OrderCommission()+OrderSwap());
				}
			}
		}
	}
	
	ProfitSum=ProfitBuy+ProfitSell;
}


long OpenOrderTicket;
double StopLoss;
double TakeProfit;
void BtnOpenBuy(double myLots,double mySL,double myTP,string myComment,string myMsg){
	
	if(myTP==0){
		TakeProfit=0;
	}else{
		TakeProfit=SymbolInfoDouble(Symbol(),SYMBOL_ASK)+myTP*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
		TakeProfit=NormalizeDouble(TakeProfit,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS));
	}
	
	if(mySL==0){
		StopLoss=0;
	}else{
		StopLoss=SymbolInfoDouble(Symbol(),SYMBOL_ASK)-mySL*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
		StopLoss=NormalizeDouble(StopLoss,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS));
	}
	
	OpenOrderTicket=OrderSend(Symbol(),OP_BUY,NormalizeDouble(myLots,2),SymbolInfoDouble(Symbol(),SYMBOL_ASK),0,StopLoss,TakeProfit,myComment,ID,0,clrNONE);
	
	if(OpenOrderTicket==-1){
		MarketError();
	}else{
		Print("Open Ticket : "+DoubleToString(OpenOrderTicket,0)+"  "+myMsg);
	}
}


void BtnOpenSell(double myLots,double mySL,double myTP,string myComment,string myMsg){
	
	if(myTP==0){
		TakeProfit=0;
	}else{
		TakeProfit=SymbolInfoDouble(Symbol(),SYMBOL_BID)-myTP*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
		TakeProfit=NormalizeDouble(TakeProfit,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS));
	}
	
	if(mySL==0){
		StopLoss=0;
	}else{
		StopLoss=SymbolInfoDouble(Symbol(),SYMBOL_BID)+mySL*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
		StopLoss=NormalizeDouble(StopLoss,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS));
	}
	
	OpenOrderTicket=OrderSend(Symbol(),OP_SELL,NormalizeDouble(myLots,2),SymbolInfoDouble(Symbol(),SYMBOL_BID),0,StopLoss,TakeProfit,myComment,ID,0,clrNONE);
	
	if(OpenOrderTicket==-1){
		MarketError();
	}else{
		Print("Open Ticket : "+DoubleToString(OpenOrderTicket,0)+"  "+myMsg);
	}
}


int OrdersTotalBuy;
int OrdersTotalSell;
int CloseOrderith;
long CloseOrderTicket;
void BtnCloseBuy(string myMsg){
	
	OrdersTotalBuy=OrdersTotal();
	
	double OrdersProfitTicketBuy[][2];
	ArrayResize(OrdersProfitTicketBuy,OrdersTotalBuy,16);
	
	for(CloseOrderith=(OrdersTotalBuy-1);CloseOrderith>=0;CloseOrderith--){
		if(OrderSelect(CloseOrderith,SELECT_BY_POS,MODE_TRADES)==true){
			OrdersProfitTicketBuy[CloseOrderith][0]=OrderProfit();
			OrdersProfitTicketBuy[CloseOrderith][1]=(double)OrderTicket();
		}
	}
	
	ArraySort(OrdersProfitTicketBuy);
	
	for(CloseOrderith=0;CloseOrderith<OrdersTotalBuy;CloseOrderith++){
		if(OrderSelect((int)OrdersProfitTicketBuy[CloseOrderith][1],SELECT_BY_TICKET,MODE_TRADES)==true){
			if(OrderMagicNumber()==ID && StringCompare(OrderSymbol(),Symbol())==0){
				if(OrderType()==OP_BUY){
					CloseOrderTicket=OrderTicket();
					if(OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(OrderSymbol(),SYMBOL_BID),0,clrNONE)==false){
						MarketError();
					}else{
						Print("Close Ticket : "+DoubleToString(CloseOrderTicket,0)+"  "+myMsg);
					}
				}
			}
		}
	}
}


void BtnCloseSell(string myMsg){
	
	OrdersTotalSell=OrdersTotal();
	
	double OrdersProfitTicketSell[][2];
	ArrayResize(OrdersProfitTicketSell,OrdersTotalSell,16);
	
	for(CloseOrderith=(OrdersTotalSell-1);CloseOrderith>=0;CloseOrderith--){
		if(OrderSelect(CloseOrderith,SELECT_BY_POS,MODE_TRADES)==true){
			OrdersProfitTicketSell[CloseOrderith][0]=OrderProfit();
			OrdersProfitTicketSell[CloseOrderith][1]=(double)OrderTicket();
		}
	}
	
	ArraySort(OrdersProfitTicketSell);
	
	for(CloseOrderith=0;CloseOrderith<OrdersTotalSell;CloseOrderith++){
		if(OrderSelect((int)OrdersProfitTicketSell[CloseOrderith][1],SELECT_BY_TICKET,MODE_TRADES)==true){
			if(OrderMagicNumber()==ID && StringCompare(OrderSymbol(),Symbol())==0){
				if(OrderType()==OP_SELL){
					CloseOrderTicket=OrderTicket();
					if(OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK),0,clrNONE)==false){
						MarketError();
					}else{
						Print("Close Ticket : "+DoubleToString(CloseOrderTicket,0)+"  "+myMsg);
					}
				}
			}
		}
	}
}


double BreakEvenPrice;
void MarketUI(){
	
	if(MathAbs(LotsBuy-LotsSell)==0){
		if(ObjectFind(ChartIDLong,"BreakEven")>-1){
			ObjectDelete(ChartIDLong,"BreakEven");
		}
	}else{
		BreakEvenPrice=NormalizeDouble((SymbolInfoDouble(Symbol(),SYMBOL_BID)-SymbolInfoDouble(Symbol(),SYMBOL_POINT)*(ProfitBuy+ProfitSell)/((LotsBuy-LotsSell)*SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE))),(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS));
		
		if(ObjectFind(ChartIDLong,"BreakEven")>-1){
			ObjectMove(ChartIDLong,"BreakEven",0,TimeCurrent(),BreakEvenPrice);
		}else{
			DrawHorizontalLine("BreakEven","",BreakEvenPrice,clrAquamarine,STYLE_DASH,1);
		}
	}
	
	DrawButton("OpenSell","SELL","Times New Roman",13,clrWhite,clrRed,10,85,70,35);
	DrawButton("OpenBuy","BUY","Times New Roman",13,clrWhite,clrBlue,110,85,70,35);
	
	DrawButton("CloseSell","Close","Times New Roman",14,clrWhite,clrCrimson,10,135,70,35);
	DrawButton("CloseBuy","Close","Times New Roman",14,clrWhite,clrMediumBlue,110,135,70,35);
	
	DrawLabel("DailyReturn","DailyReturn  "+DoubleToString(ReturnSum,2),"Times New Roman",14,clrGold,20,200);
	
	DrawLabel("LotsSell","v "+DoubleToString(LotsSell,2),"Times New Roman",14,clrDeepPink,15,230);
	DrawLabel("ProfitSell","$ "+DoubleToString(ProfitSell,2),"Times New Roman",14,clrDeepPink,15,250);
	
	DrawLabel("LotsBuy","v "+DoubleToString(LotsBuy,2),"Times New Roman",14,clrDeepSkyBlue,115,230);
	DrawLabel("ProfitBuy","$ "+DoubleToString(ProfitBuy,2),"Times New Roman",14,clrDeepSkyBlue,115,250);
}




void OnTimer(){
	
	MarketSafe();
	
	MarketHistory();
	MarketCurrent();
	
	MarketUI();
}
