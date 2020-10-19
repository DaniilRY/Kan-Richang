program kec_settings;
uses ABCObjects, graphABC, System.Windows.Forms;

var version: string = '2.6';

var border, top_line, ButtonClose, ButtonReset, frame, bPinyin, bTrans, bWindow, bTheme, counter, cPlus, cMinus, bFont: RectangleABC;
var caption, parTime, parPin, parTran, parTheme, parScreen, parFont: TextABC;
var cop, cop2: TextABC;

//По умолчанию
var def_time: integer = 4;
var def_pin: boolean = true;
var def_tran: boolean = true;
var def_over: boolean = false;
var def_theme: boolean = false;
var def_font: string = 'Arial';

var namAri: string = 'Arial(RU,EN)';
var namCal: string = 'Calibri(RU,EN)';
var namMei: string = 'Meiryo(KO,JP,CH)';
var namSim: string = 'SimSun(CH)';

//Конфигурация
var file_cfg: text;
var enadleTopMost, enablePinyin, enableTranslation, dark_theme: boolean;
var timeDelay: integer;
var handler1, handler2, num_str, handler_topmost, handler_theme, handler_font, scrap: string;
var num_cfg, err: integer;

procedure form_window(); begin
  Window.CenterOnScreen;
  MainForm.TopMost:=true;
  MainForm.FormBorderStyle:=FormBorderStyle.None;
  Window.SetSize(600, 470);
  Window.CenterOnScreen;
  border:=RectangleABC.Create(0, 0, Window.Width, Window.Height, Color.WhiteSmoke);
  top_line:=RectangleABC.Create(5, 5, Window.Width - 10, 32);
  ButtonClose:=RectangleABC.Create(top_line.Width - (16*2) - 5, top_line.Height - (16 + 3), 16*2, 16, Color.Tomato);
  ButtonClose.Text:='X';
  caption:=TextABC.Create(top_line.Position.X + 10, top_line.Position.Y + 4, 14, 'KanRichang - Параметры');
  cop:=TextABC.Create(border.Position.X + 20, border.Height - 42, 8, 'Программа: KanRichang (看日常)    Версия: ' + version + '     Автор: Мурзин Даниил Сергеевич');
  cop2:=TextABC.Create(border.Position.X + 20, cop.Position.Y + 20, 8, '2020г. Все права защищены     https://vk.com/daniiltehan');
  
  frame:=RectangleABC.Create(top_line.Position.X, top_line.Position.Y + top_line.Height + 5, top_line.Width, border.Height - 90);
  
  parTime:=TextABC.Create(frame.Position.X + 10, frame.Position.Y + 20, 14, 'Время просмотра слайда (4-60 сек)');
  parPin:=TextABC.Create(parTime.Position.X, parTime.Position.Y + 50, 14, 'Показывать пиньинь без наведения курсора?'); 
  parTran:=TextABC.Create(parTime.Position.X, parPin.Position.Y + 50, 14, 'Показывать перевод без наведения курсора?');
  parScreen:=TextABC.Create(parTime.Position.X, parTran.Position.Y + 50, 14, 'Отображать виджет поверх всех окон?');
  parTheme:=TextABC.Create(parTime.Position.X, parScreen.Position.Y + 50, 14, 'Использовать тёмную тему оформления?');
  parFont:=TextABC.Create(parTime.Position.X, parTheme.Position.Y + 50, 14, 'Тип шрифта строки перевода:');
  
  ButtonReset:=RectangleABC.Create(Round((frame.Width/2)-110), frame.Height-14, 220, 40, Color.WhiteSmoke);
  ButtonReset.Text:='Установить по умолчанию';
  
  counter:=RectangleABC.Create(frame.Width - 100, parTime.Position.Y-2, 60, 30);
  bPinyin:=RectangleABC.Create(frame.Width - 135, parPin.Position.Y-2, 60, 30, Color.WhiteSmoke);
  bTrans:=RectangleABC.Create(frame.Width - 135, parTran.Position.Y-2, 60, 30, Color.WhiteSmoke);
  bWindow:=RectangleABC.Create(frame.Width - 135, parScreen.Position.Y-2, 60, 30, Color.WhiteSmoke);
  bTheme:=RectangleABC.Create(frame.Width - 135, parTheme.Position.Y-2, 60, 30, Color.WhiteSmoke);
  
  cMinus:=RectangleABC.Create(counter.Position.X - 35, counter.Position.Y, 30, 30, Color.WhiteSmoke);
  cPlus:=RectangleABC.Create(counter.Position.X + counter.Width + 5, counter.Position.Y, 30, 30, Color.WhiteSmoke);
  
  bFont:=RectangleABC.Create(cMinus.Position.X, parFont.Position.Y-2, 130, 30, Color.WhiteSmoke);
  bFont.FontName:='Arial';
  
  cMinus.Text:='-';
  cPlus.Text:='+';
  
  counter.Text:='' + timeDelay;
  if enablePinyin = true then begin bPinyin.Text:='Да'; end else begin bPinyin.Text:='Нет' end;
  if enableTranslation = true then begin bTrans.Text:='Да'; end else begin bTrans.Text:='Нет' end;
  if enadleTopMost = true then begin bWindow.Text:='Да'; end else begin bWindow.Text:='Нет' end;
  if dark_theme = true then begin bTheme.Text:='Да'; end else begin bTheme.Text:='Нет' end;
  
  if handler_font = 'Arial' then bFont.Text:=namAri;
  if handler_font = 'Calibri' then bFont.Text:=namCal;
  if handler_font = 'Meiryo' then bFont.Text:=namMei;
  if handler_font = 'SimSun' then bFont.Text:=namSim;
  
  border.BorderColor:=Color.LightGray;
  top_line.BorderColor:=Color.LightGray;
  frame.BorderColor:=Color.LightGray;
  ButtonClose.BorderColor:=Color.LightGray;
  ButtonReset.BorderColor:=Color.LightGray;
  counter.BorderColor:=Color.LightGray;
  bPinyin.BorderColor:=Color.LightGray;
  bTrans.BorderColor:=Color.LightGray;
  bWindow.BorderColor:=Color.LightGray;
  bTheme.BorderColor:=Color.LightGray;
  bFont.BorderColor:=Color.LightGray;
  cMinus.BorderColor:=Color.LightGray;
  cPlus.BorderColor:=Color.LightGray;
end;

procedure saveSettings(); begin
  if enablePinyin = true then begin handler2:='да'; end else begin handler2:='нет' end;
  if enableTranslation = true then begin handler1:='да'; end else begin handler1:='нет' end;
  if enadleTopMost = true then begin handler_topmost:='да'; end else begin handler_topmost:='нет' end;
  if dark_theme = true then begin handler_theme:='да'; end else begin handler_theme:='нет' end;
  
  num_str:='' + timeDelay;
  
  if(FileExists('config.cfg') = true) then begin
    Assign(file_cfg, 'config.cfg');
    rewrite(file_cfg);
    
    Writeln(file_cfg, '// Время просмотра одного слайда (секунды). (По умолчанию: 4)');
    Writeln(file_cfg, num_str);
    Writeln(file_cfg, '// Показывать пиньинь без наведения курсора?  (По умолчанию: да)');
    Writeln(file_cfg, handler2);
    Writeln(file_cfg, '// Показывать перевод без наведения курсора?  (По умолчанию: да)');
    Writeln(file_cfg, handler1);
    Writeln(file_cfg, '// Отображать поверх всех окон? (По умолчанию: нет)');
    Writeln(file_cfg, handler_topmost);
    Writeln(file_cfg, '// Использовать тёмную тему оформления? (По умолчанию: нет)');
    Writeln(file_cfg, handler_theme);
    Writeln(file_cfg, '// Шрифт строки перевода (По умолчанию: Arial)');
    Writeln(file_cfg, handler_font);
    
    CloseFile(file_cfg);
  end;
end;

procedure setLightTheme(); begin 
  border.Color:=Color.WhiteSmoke;
  top_line.Color:=Color.White;
  frame.Color:=Color.White;
  
  ButtonReset.Color:=Color.WhiteSmoke;
  counter.Color:=Color.White;
  bPinyin.Color:=Color.WhiteSmoke;
  bTrans.Color:=Color.WhiteSmoke;
  bWindow.Color:=Color.WhiteSmoke;
  bTheme.Color:=Color.WhiteSmoke;
  bFont.Color:=Color.WhiteSmoke;
  cMinus.Color:=Color.WhiteSmoke;
  cPlus.Color:=Color.WhiteSmoke;
  
  border.BorderColor:=Color.LightGray;
  top_line.BorderColor:=Color.LightGray;
  frame.BorderColor:=Color.LightGray;
  ButtonClose.BorderColor:=Color.LightGray;
  ButtonReset.BorderColor:=Color.LightGray;
  counter.BorderColor:=Color.LightGray;
  bPinyin.BorderColor:=Color.LightGray;
  bTrans.BorderColor:=Color.LightGray;
  bWindow.BorderColor:=Color.LightGray;
  bTheme.BorderColor:=Color.LightGray;
  bFont.BorderColor:=Color.LightGray;
  cMinus.BorderColor:=Color.LightGray;
  cPlus.BorderColor:=Color.LightGray;
  
  ButtonReset.FontColor:=Color.Black;
  counter.FontColor:=Color.Black;
  bPinyin.FontColor:=Color.Black;
  bTrans.FontColor:=Color.Black;
  bWindow.FontColor:=Color.Black;
  bTheme.FontColor:=Color.Black;
  bFont.FontColor:=Color.Black;
  cMinus.FontColor:=Color.Black;
  cPlus.FontColor:=Color.Black;
  
  caption.Color:=Color.Black;
  parTime.Color:=Color.Black;
  parPin.Color:=Color.Black;
  parTran.Color:=Color.Black;
  parScreen.Color:=Color.Black;
  parTheme.Color:=Color.Black;
  parFont.Color:=Color.Black;
  cop.Color:=Color.Black;
  cop2.Color:=Color.Black;
end;

procedure setDarkTheme(); begin 
  border.Color:=Color.Gray;
  top_line.Color:=Color.DimGray;
  frame.Color:=Color.DimGray;
  
  ButtonReset.Color:=Color.Gray;
  counter.Color:=Color.DimGray;
  bPinyin.Color:=Color.Gray;
  bTrans.Color:=Color.Gray;
  bWindow.Color:=Color.Gray;
  bTheme.Color:=Color.Gray;
  bFont.Color:=Color.Gray;
  cMinus.Color:=Color.Gray;
  cPlus.Color:=Color.Gray;
  
  border.BorderColor:=Color.DarkGray;
  top_line.BorderColor:=Color.DarkGray;
  frame.BorderColor:=Color.DarkGray;
  ButtonClose.BorderColor:=Color.DarkGray;
  ButtonReset.BorderColor:=Color.DarkGray;
  counter.BorderColor:=Color.DarkGray;
  bPinyin.BorderColor:=Color.DarkGray;
  bTrans.BorderColor:=Color.DarkGray;
  bWindow.BorderColor:=Color.DarkGray;
  bTheme.BorderColor:=Color.DarkGray;
  bFont.BorderColor:=Color.DarkGray;
  cMinus.BorderColor:=Color.DarkGray;
  cPlus.BorderColor:=Color.DarkGray;
  
  ButtonReset.FontColor:=Color.WhiteSmoke;
  counter.FontColor:=Color.WhiteSmoke;
  bPinyin.FontColor:=Color.WhiteSmoke;
  bTrans.FontColor:=Color.WhiteSmoke;
  bWindow.FontColor:=Color.WhiteSmoke;
  bTheme.FontColor:=Color.WhiteSmoke;
  bFont.FontColor:=Color.WhiteSmoke;
  cMinus.FontColor:=Color.WhiteSmoke;
  cPlus.FontColor:=Color.WhiteSmoke;
  
  caption.Color:=Color.WhiteSmoke;
  parTime.Color:=Color.WhiteSmoke;
  parPin.Color:=Color.WhiteSmoke;
  parTran.Color:=Color.WhiteSmoke;
  parScreen.Color:=Color.WhiteSmoke;
  parTheme.Color:=Color.WhiteSmoke;
  parFont.Color:=Color.WhiteSmoke;
  cop.Color:=Color.White;
  cop2.Color:=Color.White;
end;

procedure Clicker(x, y, id: integer); begin
  if (id = 1) and (x > ButtonClose.Position.X) and (x < ButtonClose.Position.X + ButtonClose.Width) and (y > ButtonClose.Position.Y) and (y < ButtonClose.Position.Y + ButtonClose.Height) then begin
    saveSettings();
    if FileExists('KanRichang.exe') = true then Execute('KanRichang.exe');
    Window.Close;
  end;
  if (id = 1) and (x > bPinyin.Position.X) and (x < bPinyin.Position.X + bPinyin.Width) and (y > bPinyin.Position.Y) and (y < bPinyin.Position.Y + bPinyin.Height) then begin
    if enablePinyin = true then begin enablePinyin:=false; bPinyin.Text:='Нет'; end else begin enablePinyin:=true; bPinyin.Text:='Да'; end;
  end;
  if (id = 1) and (x > bTrans.Position.X) and (x < bTrans.Position.X + bTrans.Width) and (y > bTrans.Position.Y) and (y < bTrans.Position.Y + bTrans.Height) then begin
    if enableTranslation = true then begin enableTranslation:=false; bTrans.Text:='Нет'; end else begin enableTranslation:=true; bTrans.Text:='Да'; end;
  end;
  if (id = 1) and (x > bWindow.Position.X) and (x < bWindow.Position.X + bWindow.Width) and (y > bWindow.Position.Y) and (y < bWindow.Position.Y + bWindow.Height) then begin
    if enadleTopMost = true then begin enadleTopMost:=false; bWindow.Text:='Нет'; end else begin enadleTopMost:=true; bWindow.Text:='Да'; end;
  end;
  if (id = 1) and (x > bTheme.Position.X) and (x < bTheme.Position.X + bTheme.Width) and (y > bTheme.Position.Y) and (y < bTheme.Position.Y + bTheme.Height) then begin
    if dark_theme = true then begin dark_theme:=false; bTheme.Text:='Нет'; setLightTheme(); end else begin dark_theme:=true; bTheme.Text:='Да'; setDarkTheme(); end;
  end;
  
  if (id = 1) and (x > bFont.Position.X) and (x < bFont.Position.X + bFont.Width) and (y > bFont.Position.Y) and (y < bFont.Position.Y + bFont.Height) then begin
    if handler_font = 'Arial' then begin handler_font:='Calibri'; bFont.Text:=namCal; end
    else if handler_font = 'Calibri' then begin handler_font:='Meiryo'; bFont.Text:=namMei; end
    else if handler_font = 'Meiryo' then begin handler_font:='SimSun'; bFont.Text:=namSim; end
    else if handler_font = 'SimSun' then begin handler_font:='Arial'; bFont.Text:=namAri; end
  end;
  
  if (id = 1) and (x > cMinus.Position.X) and (x < cMinus.Position.X + cMinus.Width) and (y > cMinus.Position.Y) and (y < cMinus.Position.Y + cMinus.Height) then begin
    if timeDelay > 4 then timeDelay:=timeDelay - 1; counter.Text:='' + timeDelay; begin end;
  end;
  if (id = 1) and (x > cPlus.Position.X) and (x < cPlus.Position.X + cPlus.Width) and (y > cPlus.Position.Y) and (y < cPlus.Position.Y + cPlus.Height) then begin
    if timeDelay < 60 then timeDelay:=timeDelay + 1; counter.Text:='' + timeDelay; begin end;
  end;
  
  if (id = 1) and (x > ButtonReset.Position.X) and (x < ButtonReset.Position.X + ButtonReset.Width) and (y > ButtonReset.Position.Y) and (y < ButtonReset.Position.Y + ButtonReset.Height) then begin
    timeDelay:=def_time;
    enablePinyin:=def_pin;
    enableTranslation:=def_tran;
    enadleTopMost:=def_over;
    dark_theme:=def_theme;
    
    handler_font:=def_font;
    if handler_font = 'Arial' then bFont.Text:=namAri;
    if handler_font = 'Calibri' then bFont.Text:=namCal;
    if handler_font = 'Meiryo' then bFont.Text:=namMei;
    if handler_font = 'SimSun' then bFont.Text:=namSim;
    
    counter.Text:='' + timeDelay;
    if enablePinyin = true then begin bPinyin.Text:='Да'; end else begin bPinyin.Text:='Нет' end;
    if enableTranslation = true then begin bTrans.Text:='Да'; end else begin bTrans.Text:='Нет' end;
    if enadleTopMost = true then begin bWindow.Text:='Да'; end else begin bWindow.Text:='Нет' end;
    if def_theme = true then begin bTheme.Text:='Да'; end else begin bTheme.Text:='Нет' end;
    if dark_theme = false then begin setLightTheme; end else begin setDarkTheme; end;
  end;
end;

procedure readSettings(); begin
  if(FileExists('config.cfg') = true) then begin
    Assign(file_cfg, 'config.cfg');
    Reset(file_cfg);
    
    readLn(file_cfg, scrap);
    readLn(file_cfg, num_str);
    readLn(file_cfg, scrap);
    readLn(file_cfg, handler2);
    readLn(file_cfg, scrap);
    readLn(file_cfg, handler1);
    readLn(file_cfg, scrap);
    readLn(file_cfg, handler_topmost);
    readLn(file_cfg, scrap);
    readLn(file_cfg, handler_theme);
    readLn(file_cfg, scrap);
    readLn(file_cfg, handler_font);
    
    CloseFile(file_cfg);
    
    Val(num_str, num_cfg, err);
    timeDelay:=num_cfg;
    
    if (handler1 = 'Да') or (handler1 = 'да') or (handler1 = 'ДА') or (handler1 = 'дА') then begin
      enableTranslation:=true;
    end else begin
      enableTranslation:=false;
    end;
    
    if (handler2 = 'Да') or (handler2 = 'да') or (handler2 = 'ДА') or (handler2 = 'дА') then begin
      enablePinyin:=true;
    end else begin
      enablePinyin:=false;
    end;
    
    if (handler_topmost = 'Да') or (handler_topmost = 'да') or (handler_topmost = 'ДА') or (handler_topmost = 'дА') then begin
      enadleTopMost:=true;
    end else begin
      enadleTopMost:=false;
    end;
    
    if (handler_theme = 'Да') or (handler_theme = 'да') or (handler_theme = 'ДА') or (handler_theme = 'дА') then begin
      dark_theme:=true;
    end else begin
      dark_theme:=false;
    end;
    
  end else begin
    dark_theme:=false;
    handler_font:='Arial';
    enadleTopMost:=false;
    enableTranslation:=true;
    enablePinyin:=true;
    timeDelay:=4000;
  end;
end;

begin
  //if FileExists('KanRichang.exe') = false then Window.Close;
  readSettings();
  form_window();
  if dark_theme = true then setDarkTheme;
  OnMouseDown:= Clicker;
end.