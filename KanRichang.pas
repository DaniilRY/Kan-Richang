program KanRichang;
uses ABCObjects, graphABC, System.Windows.Forms;

var BackgroundRect, RectH, RectP, RectT: RectangleABC;
var CloseButton, PositionButton, SettingsButton: RectangleABC;

var current_position: string = 'right';

var file_cfg: text;
var arr_size: integer;

var arrH: array of string;
var arrP: array of string;
var arrT: array of string;

var isRun: boolean = true;
var randNum, currentNum: integer;

var enableTranslation: boolean;
var enablePinyin: boolean;
var enadleTopMost: boolean = false;
var dark_theme: boolean = false;
var timeDelay: integer = 4000;

var handler1, handler2, num_str, handler_topmost, handler_theme, handler_font, scrap: string;
var num_cfg, err: integer;
var menu, menu2: boolean;

procedure Redraw(); begin
  if (arr_size = 1) then begin
    if(menu = true) and (enableTranslation = false) then begin
      RectT.Text:='' + arrT[0];
      if dark_theme = true then begin RectT.Color:=color.DimGray; end else begin RectT.Color:=color.White; end;
    end;
    if(menu = false) and (enableTranslation = false) then begin
      RectT.Text:='';
      if dark_theme = true then begin RectT.Color:=color.Gray; end else begin RectT.Color:=color.WhiteSmoke; end;
    end;
  end;
  if (arr_size <> 1) then begin
    if(menu = true) and (enableTranslation = false) then begin
      RectT.Text:='' + arrT[randNum];
      if dark_theme = true then begin RectT.Color:=color.DimGray; end else begin RectT.Color:=color.White; end;
    end;
    if(menu = false) and (enableTranslation = false) then begin
      RectT.Text:='';
      if dark_theme = true then begin RectT.Color:=color.Gray; end else begin RectT.Color:=color.WhiteSmoke; end;
    end;
  end;
  
  if (arr_size = 1) then begin
    if(menu2 = true) and (enablePinyin = false) then begin
      RectP.Text:='' + arrP[0];
      if dark_theme = true then begin RectP.Color:=color.DimGray; end else begin RectP.Color:=color.White; end;
    end;
    if(menu2 = false) and (enablePinyin = false) then begin
      RectP.Text:='';
      if dark_theme = true then begin RectP.Color:=color.Gray; end else begin RectP.Color:=color.WhiteSmoke; end;
    end;
  end;
  if (arr_size <> 1) then begin
    if(menu2 = true) and (enablePinyin = false) then begin
      RectP.Text:='' + arrP[randNum];
      if dark_theme = true then begin RectP.Color:=color.DimGray; end else begin RectP.Color:=color.White; end;
    end;
    if(menu2 = false) and (enablePinyin = false) then begin
      RectP.Text:='';
      if dark_theme = true then begin RectP.Color:=color.Gray; end else begin RectP.Color:=color.WhiteSmoke; end;
    end;
  end;
end;

procedure setPosition(position: string); begin
  if(position = 'left') then window.SetPos(1, 1);
  if(position = 'right') then window.SetPos(Screen.PrimaryScreen.Bounds.Width - window.Width, 1);
  current_position:=position;
end;

procedure MouseMove(x, y, mb: integer); begin
  if (enableTranslation = false) then begin
    if (x >= RectT.Position.X) and (x <= RectT.Position.X + RectT.Width) and (y >= RectT.Position.Y) and (y <= RectT.Position.Y + RectT.Height) then begin
      menu:=true;
    end else begin
      menu:=false;
    end;
  end;
  if (enablePinyin = false) then begin
    if (x >= RectP.Position.X) and (x <= RectP.Position.X + RectP.Width) and (y >= RectP.Position.Y) and (y <= RectP.Position.Y + RectP.Height) then begin
      menu2:=true;
    end else begin
      menu2:=false;
    end;
  end;
  Redraw();
end;

procedure Clicker(x, y, id: integer); begin
  if(id = 1) then begin
    if(x>= CloseButton.Position.X) and (x <= CloseButton.Position.X + CloseButton.Width) and (y >= CloseButton.Position.Y) and (y <= CloseButton.Position.Y + CloseButton.Height) then begin
      isRun:=false;
      window.Close;
    end;
  end;
  if(id = 1) then begin
    if(x>= PositionButton.Position.X) and (x <= PositionButton.Position.X + PositionButton.Width) and (y >= PositionButton.Position.Y) and (y <= PositionButton.Position.Y + PositionButton.Height) then begin
      if(current_position = 'right') then begin setPosition('left'); end
      else begin setPosition('right'); end;
    end;
  end;
  if(id = 1) then begin
    if(x>= SettingsButton.Position.X) and (x <= SettingsButton.Position.X + SettingsButton.Width) and (y >= SettingsButton.Position.Y) and (y <= SettingsButton.Position.Y + SettingsButton.Height) then begin
      isRun:=false;
      if FileExists('Settings.exe') = true then Execute('Settings.exe');
      window.Close;
    end;
  end;
end;

procedure setWindow(width, height: integer; position: string); begin
  window.Clear(color.Azure);
  MainForm.TopMost:=enadleTopMost;
  MainForm.FormBorderStyle:=FormBorderStyle.None;
  MainForm.TransparencyKey:=color.Azure;
  Window.SetSize(width, height-25);
  setPosition(position);
  
  BackgroundRect:=RectangleABC.Create(0, 0, window.Width - 1, window.Height - 1, color.WhiteSmoke);
  BackgroundRect.BorderWidth:=1;
  
  CloseButton:=RectangleABC.Create(window.Width - 41, 5, 16*2, 16, Color.Tomato);
  SettingsButton:=RectangleABC.Create(10, 5, 16, 16, Color.CornflowerBlue);
  PositionButton:=RectangleABC.Create(SettingsButton.Position.X + (SettingsButton.Width + 5), SettingsButton.Position.Y, 16, 16, color.CornflowerBlue);
  
  RectH:=RectangleABC.Create(10, 25, window.Width-20, 80);
  RectP:=RectangleABC.Create(RectH.Position.X, RectH.Position.Y + RectH.Height + 5, RectH.Width, 32);
  RectT:=RectangleABC.Create(RectP.Position.X, RectP.Position.Y + RectP.Height + 5, RectP.Width, RectP.Height);
  
  BackgroundRect.BorderColor:=Color.LightGray;
  RectH.BorderColor:=Color.LightGray;
  RectP.BorderColor:=Color.LightGray;
  RectT.BorderColor:=Color.LightGray;
  CloseButton.BorderColor:=Color.LightGray;
  PositionButton.BorderColor:=Color.LightGray;
  SettingsButton.BorderColor:=Color.LightGray;
  
  if dark_theme = true then begin
    BackgroundRect.Color:=Color.Gray;
    RectH.Color:=Color.DimGray;
    RectP.Color:=Color.DimGray;
    RectT.Color:=Color.DimGray;
    RectH.FontColor:=Color.WhiteSmoke;
    RectP.FontColor:=Color.WhiteSmoke;
    RectT.FontColor:=Color.WhiteSmoke;
    BackgroundRect.BorderColor:=Color.DarkGray;
    RectH.BorderColor:=Color.DarkGray;
    RectP.BorderColor:=Color.DarkGray;
    RectT.BorderColor:=Color.DarkGray;
    CloseButton.BorderColor:=Color.DarkGray;
    PositionButton.BorderColor:=Color.DarkGray;
    SettingsButton.BorderColor:=Color.DarkGray;
  end;
  
  RectP.FontStyle:=FontStyleType.fsBold;
  RectH.FontName:='SimSun';
  RectP.FontName:='Calibri';
  RectT.FontName:=handler_font;
  CloseButton.Text:='X';
  PositionButton.Text:='< >';
  SettingsButton.Text:='=';
  
  if (enableTranslation = false) then begin RectT.Color:=color.WhiteSmoke; if dark_theme = true then RectT.Color:=color.Gray; end;
  if (enablePinyin = false) then begin RectP.Color:=color.WhiteSmoke; if dark_theme = true then RectP.Color:=color.Gray; end;
end;

procedure scanSize(); begin
  if (FileExists('database\list_hieroglyph.txt') = true) then begin
    Assign(file_cfg, 'database\list_hieroglyph.txt');
    Reset(file_cfg);
    while Not Eof(file_cfg) do begin
      readLn(file_cfg, scrap);
      arr_size+=1;
    end;
    CloseFile(file_cfg);
  end;
  
  SetLength(arrH, arr_size);
  SetLength(arrP, arr_size);
  SetLength(arrT, arr_size);
end;

procedure readConfig(); begin
  if(FileExists('database\list_hieroglyph.txt') = true) then begin
    Assign(file_cfg, 'database\list_hieroglyph.txt');
    Reset(file_cfg);
    for var i:=0 to arrH.Length-1 do begin
      readLn(file_cfg, arrH[i]);
    end;
    CloseFile(file_cfg);
  end;
  
  if(FileExists('database\list_pinyin.txt') = true) then begin
    Assign(file_cfg, 'database\list_pinyin.txt');
    Reset(file_cfg);
    for var i:=0 to arrP.Length-1 do begin
      readLn(file_cfg, arrP[i]);
    end;
    CloseFile(file_cfg);
  end;
  
  if(FileExists('database\list_translate.txt') = true) then begin
    Assign(file_cfg, 'database\list_translate.txt');
    Reset(file_cfg);
    for var i:=0 to arrT.Length-1 do begin
      readLn(file_cfg, arrT[i]);
    end;
    CloseFile(file_cfg);
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
    timeDelay:=1000 * num_cfg;
    
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

procedure RedrawScreen(); begin
  currentNum:=randNum;
  
  if (arr_size = 1) then begin
    RectH.Text:='' + arrH[0];
    if (enableTranslation = true) then RectT.Text:='' + arrT[0];
    if (enableTranslation = false) and (menu = true) then RectT.Text:='' + arrT[0];
    if (enablePinyin = true) then RectP.Text:='' + arrP[0];
    if (enablePinyin = false) and (menu2 = true) then RectP.Text:='' + arrP[0];
  end;
  if (arr_size <> 1) then begin
    while currentNum = randNum do begin
      randNum:=random(0, arrH.Length-1);
    end;
    if (randNum <= arrH.Length-1) and (arrH.Length > 1) then RectH.Text:='' + arrH[randNum];
    if (enableTranslation = true) then if (randNum <= arrT.Length-1) and (arrT.Length > 1) then RectT.Text:='' + arrT[randNum];
    if (enableTranslation = false) and (menu = true) then if (randNum <= arrT.Length-1) then RectT.Text:='' + arrT[randNum];
    if (enablePinyin = true) then if (randNum <= arrP.Length-1) and (arrP.Length > 1) then RectP.Text:='' + arrP[randNum];
    if (enablePinyin = false) and (menu2 = true) then if (randNum <= arrP.Length-1) and (arrP.Length > 1) then RectP.Text:='' + arrP[randNum];
  end;
end;

procedure Timer(delay: integer); begin
  while isRun do begin
    RedrawScreen();
    sleep(delay);
  end;
end;

begin
  scanSize();
  readConfig();
  readSettings();
  setWindow(round(Screen.PrimaryScreen.Bounds.Width/7), round(Screen.PrimaryScreen.Bounds.Height/4), current_position);
  OnMouseDown:= Clicker;
  OnMouseMove:= MouseMove;
  Timer(timeDelay);
end.