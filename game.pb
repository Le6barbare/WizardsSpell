;-
;-- Initialisation du systeme

;----- Librairies
  InitSprite()
  InitMouse()
  InitKeyboard()
  If InitJoystick()
    Global EnableJoystick = 1
  EndIf
  InitSound()

;----- Décodeur des formats images
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  UseOGGSoundDecoder()

;----- VARIABLES
  Global i,j,Angle=0,DirectionKey=0,SpellKey=0,TimeSort=3,Score=0,TempoMonstre
  Global luneWait=0, luneX.f=1024/2-200, luneY.f=0, initCentrLuneX=1024/2, initCentrLuneY=250, multi, nbnuit = 1
  Global nuage1.f=Random(1024), nuage2.f=Random(1024), nuage3.f=Random(1024), nuage4.f=Random(1024), nuage5.f=Random(1024)
  Global tirage, precedant1, precedant2
  Global SelectMenu=0,TempoMenu=50,Mode,Quit, TempoStory=1000,GameLaunch=0
  Global nbfeuMax=10,nbetoileMax=15,Vie,viePerdu, FlamNum=1,timerGameOver,tempoMusicGame,tempoMusicMenu,lightning=1
  Global TempoMonstreSpe=0
  Global etoileAnim, etoileWaitAnim

; Tableaux
  Global Dim Sorts(3), Dim PositionEffetSort(6)
  Global Dim flamAnim(4), Dim flamWaitAnim(4)
  Global Dim Monstre(6), Dim TempoRepopMonstre(3)

  Global Dim feuX(nbfeuMax),Dim feuY(nbfeuMax),Dim fireBool(nbfeuMax)
  Global Dim etoileX(nbetoileMax),Dim etoileY(nbetoileMax)

;- PROCEDURE
  Declare Menu()
  Declare GAME()
  Declare AffText(Text$,x.i,y.i,light.i)
  Declare Flamme()
  Declare etoile()

;Ouvre un Screen Plein écran
  OpenScreen(1024, 768, 32, "")

;Clavier en mode International
  KeyboardMode(#PB_Keyboard_International)

;-Chargement Sound
  LoadSound(1,"Ressources/sound/Bruitage/game-over.ogg")
  LoadSound(2,"Ressources/sound/Bruitage/changement-sort.ogg")
  LoadSound(3,"Ressources/sound/Bruitage/menu.ogg")
  LoadSound(4,"Ressources/sound/Bruitage/tir-baguette1.ogg")
  
  LoadSound(5,"Ressources/sound/Musiques/ambiance.ogg")
  LoadSound(6,"Ressources/sound/Musiques/boucle.ogg")
  
  LoadSound(9,"Ressources/sound/Enregistrement/Welcome.ogg")
  LoadSound(10,"Ressources/sound/Enregistrement/Story.ogg")
  LoadSound(11,"Ressources/sound/Bruitage/grougrou1.ogg")

;-Chargement sprite
  LoadSprite(1,"Ressources/img/background-alpha.png")
  LoadSprite(2,"Ressources/img/HUB/Interface.png",#PB_Sprite_AlphaBlending)
  LoadSprite(3,"Ressources/img/Sort/livre-rouge.png",#PB_Sprite_AlphaBlending)
  LoadSprite(4,"Ressources/img/Sort/livre-vert.png",#PB_Sprite_AlphaBlending)
  LoadSprite(5,"Ressources/img/Sort/livre-blanc.png",#PB_Sprite_AlphaBlending)
  LoadSprite(6,"Ressources/img/Animation/baguette.png",#PB_Sprite_AlphaBlending)
  LoadSprite(7,"Ressources/img/Sort/sort-rouge.png",#PB_Sprite_AlphaBlending)
  LoadSprite(8,"Ressources/img/Sort/sort-vert.png",#PB_Sprite_AlphaBlending)
  LoadSprite(9,"Ressources/img/Sort/sort-blanc.png",#PB_Sprite_AlphaBlending)
  LoadSprite(10,"Ressources/img/Lune/lune.png",#PB_Sprite_AlphaBlending)
  LoadSprite(11,"Ressources/img/Monstres/monstre-rouge.png",#PB_Sprite_AlphaBlending)
  LoadSprite(12,"Ressources/img/Monstres/monstre-vert2.png",#PB_Sprite_AlphaBlending)
  LoadSprite(13,"Ressources/img/Monstres/monstre-blanc.png",#PB_Sprite_AlphaBlending)
  LoadSprite(14,"Ressources/img/Monstres/monstre-spe.png",#PB_Sprite_AlphaBlending)
  
  LoadSprite(21,"Ressources/img/Animation/nuage1.png",#PB_Sprite_AlphaBlending)
  LoadSprite(22,"Ressources/img/Animation/nuage2.png",#PB_Sprite_AlphaBlending)
  LoadSprite(23,"Ressources/img/Animation/montage-eau.png",#PB_Sprite_AlphaBlending)
  
  LoadSprite(31,"Ressources/img/TitleScreen/blackBG.png")
  LoadSprite(32,"Ressources/img/TitleScreen/title.png",#PB_Sprite_AlphaBlending)
  LoadSprite(33,"Ressources/img/TitleScreen/jouer.png",#PB_Sprite_AlphaBlending)
  LoadSprite(34,"Ressources/img/TitleScreen/jouer2.png",#PB_Sprite_AlphaBlending)
  LoadSprite(35,"Ressources/img/TitleScreen/quitter.png",#PB_Sprite_AlphaBlending)
  LoadSprite(36,"Ressources/img/TitleScreen/quitter2.png",#PB_Sprite_AlphaBlending)
  LoadSprite(37,"Ressources/img/TitleScreen/story.png",#PB_Sprite_AlphaBlending)
  LoadSprite(38,"Ressources/img/TitleScreen/game-over.png",#PB_Sprite_AlphaBlending)
  LoadSprite(39,"Ressources/img/TitleScreen/page-controle.png",#PB_Sprite_AlphaBlending)
  LoadSprite(40,"Ressources/img/TitleScreen/controle.png",#PB_Sprite_AlphaBlending)
  LoadSprite(41,"Ressources/img/TitleScreen/controle2.png",#PB_Sprite_AlphaBlending)
  LoadSprite(42,"Ressources/img/TitleScreen/credits.png",#PB_Sprite_AlphaBlending)
  LoadSprite(43,"Ressources/img/TitleScreen/credits0.png",#PB_Sprite_AlphaBlending)
  LoadSprite(44,"Ressources/img/TitleScreen/credits1.png",#PB_Sprite_AlphaBlending)

 ;- Chargement du feu
  LoadImage(300,"Ressources/img/Animation/flamme2.png",#PB_Sprite_AlphaBlending)

  For j=0 To 4
    GrabImage(300,1,j*320/5,0, (j+1)*320/5,64)
    CreateSprite(300+j,320/5,64,#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(j+300))
    DrawImage(ImageID(1),0,0)
    StopDrawing()
    TransparentSpriteColor(j+300,RGB(0,0,0)) 
  Next
  
 ;- Chargement des etoile
For i=1 To 7
  LoadSprite(600+i,"Ressources/img/Animation/Etoile/etoile"+Str(i)+".png",#PB_Sprite_AlphaBlending)
  TransparentSpriteColor(600+i,RGB(255,255,255)) ; Couleur de  transparence
Next

;- Creation de la bare de Vie
  CreateSprite(20,10,5,#PB_Sprite_AlphaBlending)
  StartDrawing(SpriteOutput(20))
  Box(0,0,10,5,RGB(255,0,0))
  StopDrawing()
 
;- Chargement Font
  LoadImage(200,"Ressources/img/Font.bmp")        ; Charge l'image de toutes les lettres
  For j=0 To 125-33                               ; Fait une boucle de toutes les lettres
    GrabImage(200,j,j*16,0,j*16+16,16)            ; Découpe lettre par lettre
    CreateSprite(j+200,16,16)                     ; Crée un sprite pour chaque lettre
    StartDrawing(SpriteOutput(j+200))
      DrawImage(ImageID(j),0,0)                   ; Place la lettre découpée dans le sprite
      StopDrawing()
  Next

  For i=0 To nbfeuMax
    feuX(i)=Random(840,640)
    feuY(i)=Random(670,580)
  Next
  
  For i=0 To nbetoileMax
    etoileX(i)=Random(1024,0)
    etoileY(i)=Random(310,0)
  Next

  Mode=0
;-  *********************  
;--  START GAME LOOP&
;- 
  Repeat
    ExamineKeyboard()
    ExamineMouse()
    If EnableJoystick
      ExamineJoystick(0)
    EndIf
   
    If Mode=0: Menu():EndIf
    If Mode=1: GAME():EndIf
  
    FlipBuffers()
    Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1
  End
;- 
;--  END GAME LOOP
;-  *********************


;- PROCEDURES
  Procedure Menu()
  tempoMusicMenu+1
  If tempoMusicMenu<5: PlaySound(6, #PB_Sound_Loop):EndIf
  tempoMusicGame=0
  PlaySound(9,100)
    If GameLaunch=0  
      DisplaySprite(31,0,0)
      DisplayTransparentSprite(32,58,54)
      ;AffText(Str(SelectMenu),200,200,255)
      If EnableJoystick
        If JoystickAxisX(0)=1 Or JoystickAxisY(0)=1
          If TempoMenu<=5
            PlaySound(3,#PB_Sound_MultiChannel)
            SelectMenu+1
            If SelectMenu>3 : SelectMenu=0 :  EndIf
            TempoMenu=50
          EndIf
        EndIf
        If JoystickAxisX(0)=-1 Or JoystickAxisY(0)=-1
          If TempoMenu<=5
            PlaySound(3,#PB_Sound_MultiChannel)
            SelectMenu-1
            If SelectMenu>0 : SelectMenu=3 :  EndIf
            TempoMenu=50
          EndIf
        EndIf
      Else
        If KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_S)
          If TempoMenu<=5
            PlaySound(3,#PB_Sound_MultiChannel)
            SelectMenu+1
            If SelectMenu>3 : SelectMenu=0 :  EndIf
            TempoMenu=50
          EndIf
        EndIf
        If KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Z)
          If TempoMenu<=5
            PlaySound(3,#PB_Sound_MultiChannel)
            SelectMenu-1
            If SelectMenu<0 : SelectMenu=3 :  EndIf
            TempoMenu=50
          EndIf
        EndIf
      EndIf
      If TempoMenu>5
        TempoMenu-2
      EndIf
      If SelectMenu=0
      ; ! Play !
        DisplayTransparentSprite(34,327,295)
        ;Controles
        DisplayTransparentSprite(40,300,371)
        ;Quit
        DisplayTransparentSprite(35,300,523)
        ; ! credit !
        DisplayTransparentSprite(43,325,447)
      ElseIf SelectMenu=1
      ;Play
        DisplayTransparentSprite(33,327,295)
        ; ! Controles !
        DisplayTransparentSprite(41,300,371)
        ;Quit
        DisplayTransparentSprite(35,300,523)
        ; ! credit !
        DisplayTransparentSprite(43,325,447)
      ElseIf SelectMenu=3
      ;Play
        DisplayTransparentSprite(33,327,295)
      ;Controles
        DisplayTransparentSprite(40,300,371)
      ; ! Quit !
        DisplayTransparentSprite(36,300,523)
      ; ! credit !
        DisplayTransparentSprite(43,325,447)
      ElseIf SelectMenu=2
      ;Play
        DisplayTransparentSprite(33,327,295)
      ;Controles
        DisplayTransparentSprite(40,300,371)
      ; ! Quit !
        DisplayTransparentSprite(35,300,523)
      ; ! credit !
        DisplayTransparentSprite(44,325,447)
      EndIf
      
      If EnableJoystick
        If JoystickButton(0, 1) Or JoystickButton(0, 2) Or JoystickButton(0, 3) Or JoystickButton(0, 4)
          If SelectMenu=0
            GameLaunch=1
          ElseIf SelectMenu=1
            DisplaySprite(39,0,0)
          ElseIf SelectMenu=2
            DisplaySprite(42,0,0)
          Else
            Quit=1
          EndIf
        EndIf
      Else
        If KeyboardPushed(#PB_Key_Space) Or KeyboardPushed(#PB_Key_Return)
          If SelectMenu=0
            GameLaunch=1
          ElseIf SelectMenu=1
            DisplaySprite(39,0,0)
          ElseIf SelectMenu=2
            DisplaySprite(42,0,0)
          Else
            Quit=1
          EndIf
        EndIf
      EndIf
      
      ;-song menu
      StopSound(9)
        If IsSound(10)
          PlaySound(10)
        EndIf 
      
    ElseIf GameLaunch=1
      StopSound(6)
      DisplaySprite(37,0,0)
      TempoStory-1
      ;AffText("TempoStory:" + Str(TempoStory),600,50,255)
      ;AffText("Espace/entrer pour commencer",100,675,255)
      If TempoStory<900
        If EnableJoystick
          If JoystickButton(0, 1) Or JoystickButton(0, 2) Or JoystickButton(0, 3) Or JoystickButton(0, 4)
            TempoStory=0
          EndIf
        Else
          If KeyboardPushed(#PB_Key_Space) Or KeyboardPushed(#PB_Key_Return) Or KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q) Or KeyboardPushed(#PB_Key_S) Or KeyboardPushed(#PB_Key_D) Or KeyboardPushed(#PB_Key_Z)  Or KeyboardPushed(#PB_Key_K) Or KeyboardPushed(#PB_Key_L) Or KeyboardPushed(#PB_Key_M)
            TempoStory=0
          EndIf
        EndIf
      EndIf
      If TempoStory<5
        Mode=1
        ;GameLaunch=0
      EndIf
      
      ;-- initialisation partie
        Score=0
        Sorts(1)= 3
        Sorts(2)= 4
        Sorts(3)= 5
        PositionEffetSortX=380
        PositionEffetSortY=565
        Monstre(1)=Random(3,1)
        Monstre(2)=Random(3,1)
        Monstre(3)=Random(3,1)
        Monstre(4)=50
        Monstre(5)=50
        Monstre(6)=50
        TempoRepopMonstre(1)=Random(300,50)
        TempoRepopMonstre(2)=Random(300,50)
        TempoRepopMonstre(3)=Random(300,50)
        Vie=10
        nbnuit=1
        luneX.f=1024/2-200
        luneY.f=0
        multi=0
        nuage1.f=Random(1024)
        nuage2.f=Random(1024)
        nuage3.f=Random(1024)
        nuage4.f=Random(1024)
        nuage5.f=Random(1024) 
    EndIf
  
  EndProcedure
  
  Procedure GAME()
  tempoMusicMenu=0
  StopSound(10)
    tempoMusicGame+1
    If tempoMusicGame<5
    PlaySound(5,#PB_Sound_Loop)
    EndIf

    DisplaySprite(1,0,0)
    
;     ;-Affichage des etoile;  
;      For j=0 To nbetoileMax
;          etoileWaitAnim+1
;          If etoileWaitAnim>10
;            etoileWaitAnim=0
;            etoileAnim+1
;            If etoileAnim>7 :  etoileAnim=0 : EndIf       
;             DisplayTransparentSprite(600+etoileAnim,etoileX(j),etoileY(j),255)  
;          EndIf
;      Next
    
    
  ;--calcul trajectoire lune
    luneWait = luneWait + 1
    If luneWait>10
      If luneX.f<1024/2 : multi = multi + 1 : EndIf
      If luneX.f>1024/2 : multi = multi - 1 : EndIf
      If luneX.f>1024/2+200 : luneX.f=1024/2-200 : nbNuit+1 :
      
        If nbNuit=3
          lightning=2
        ElseIf nbnuit=6
          lightning=3
        ElseIf nbnuit=9
          lightning=4
        ElseIf nbnuit=12
          lightning=5
        ElseIf nbnuit=15
          lightning=6
        ElseIf nbnuit=18
          lightning=7
        ElseIf nbnuit=20
          lightning=10
        EndIf

      ;-melange des grimoires
        tirage = Random(5,3)
        precedant1 = tirage
        Sorts(1) = tirage
        tirage = Random(5,3)
        While tirage = precedant1
          tirage = Random(5,3)
        Wend
        precedant2 = tirage
        Sorts(2) = tirage
        tirage = Random(5,3)
        While tirage = precedant2 Or tirage = precedant1
          tirage = Random(5,3)
        Wend
        Sorts(3) = tirage
        
        TempoMonstreSpe=50
        PlaySound(2)
      EndIf
      luneX.f = luneX.f + multi/30
      luneWait=0
    EndIf
    
    luneY.f = initCentrLuneY-Sqr(200*200-(luneX.f-initCentrLuneX)*(luneX.f-initCentrLuneX)) 
    DisplayTransparentSprite(10,luneX,luneY,255)
    DisplayTransparentSprite(23,2,274,255)
    
  ;-info text interface
    AffText("Score : " + Str(Score),800-30,45,255)
    AffText("PV:" + Str(Vie),800-30,25,255)
    AffText("Nuit : "+ Str(nbNuit),800-30,5,255)
    
  ;-- trajectoire nuages 
    nuage1.f+1/5
    If nuage1.f>1024 : nuage1.f = 0-100 : EndIf
    DisplayTransparentSprite(21,nuage1.f,100,255)
   
    nuage2.f+1/3
    If nuage2.f>1024 : nuage2.f = 0-100 : EndIf
    DisplayTransparentSprite(22,nuage2.f,150,255)
   
    nuage3.f+1/8
    If nuage3>1024 : nuage3.f = 0-100 : EndIf
    DisplayTransparentSprite(21,nuage3.f,200,255)
   
    nuage4.f+1/2
    If nuage4.f>1024 : nuage4.f = 0-100 : EndIf
    DisplayTransparentSprite(22,nuage4.f,250,255)
   
    nuage5.f+1/4
    If nuage5.f>1024 : nuage5.f = 0-100 : EndIf
    DisplayTransparentSprite(21,nuage5.f,300,255)
  
  ;-affiche interface
    DisplayTransparentSprite(2,0,0) 
  
  ;-- affichage des grimoires
    DisplayTransparentSprite(Sorts(1),2,2)
    DisplayTransparentSprite(Sorts(2),110,2)
    DisplayTransparentSprite(Sorts(3),210,2)
    
  ;-affichage des monstres
    If Monstre(1)<>0
      DisplayTransparentSprite(Monstre(1)+10,190,360,Monstre(4))
    EndIf
    If Monstre(2)<>0
      DisplayTransparentSprite(Monstre(2)+10,455,360,Monstre(5))
    EndIf
    If Monstre(3)<>0
      DisplayTransparentSprite(Monstre(3)+10,710,360,Monstre(6))
    EndIf

  ;-- Gestion de la baguette
    If DirectionKey=0
      If EnableJoystick    
        If JoystickAxisX(0)=-1
          DirectionKey=1
        ElseIf JoystickAxisX(0)=1
          DirectionKey=3
          Angle+10
        ElseIf JoystickAxisY(0)=-1
          DirectionKey=2
        EndIf
      Else
        If KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q)
          DirectionKey=1
        ElseIf KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_D)
          DirectionKey=3
          Angle+10
        ElseIf KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Z)
          DirectionKey=2
        EndIf
      EndIf
    EndIf
     
    If DirectionKey=1
      If Angle>-20
        Angle-10
      Else
        DirectionKey=0
      EndIf
    EndIf
    
    If DirectionKey=2
      If Angle<0
        Angle+10
      ElseIf Angle>0
        Angle-10
      Else
        DirectionKey=0
      EndIf
    EndIf
    
    If DirectionKey=3
      If Angle<20
        Angle+10
      Else
        Angle=20
        DirectionKey=0
      EndIf
    EndIf
    
  ;-- Gestion Sorts
    ; Coordonées affichage sort
    If Angle=-20 ; Baguette a gauche
      Angle=-20
      PositionEffetSortX=317
      PositionEffetSortY=497
      PositionEffetHitMonstreX=190-65
      PositionEffetHitMonstreY=360-50
    ElseIf Angle=0 ; Baguette au centre
      PositionEffetSortX=385
      PositionEffetSortY=485
      PositionEffetHitMonstreX=455-65
      PositionEffetHitMonstreY=360-50
    ElseIf Angle=20 ; Baguette a droite
      Angle=20
      PositionEffetSortX=452
      PositionEffetSortY=497
      PositionEffetHitMonstreX=710-65
      PositionEffetHitMonstreY=360-50
    EndIf
    
    ; Rotation et affichage
    RotateSprite(6,Angle,0)
    DisplayTransparentSprite(6,300,600,255)
    
    ; Affichage Sort
    If EnableJoystick
      If JoystickButton(0, 3) And JoystickButtonPressed=0 And SpellKey=0
        JoystickButtonPressed=1
        SpellKey=1
        TimeSort=6
      ElseIf  Or JoystickButton(0, 1) And JoystickButtonPressed=0 And SpellKey=0
        JoystickButtonPressed=1
        SpellKey=2
        TimeSort=6
      ElseIf  Or JoystickButton(0, 2) And JoystickButtonPressed=0 And SpellKey=0
        JoystickButtonPressed=1
        SpellKey=3
        TimeSort=6
      EndIf
    Else
      If KeyboardPushed(#PB_Key_K) And SpellKey=0
        SpellKey=1
        TimeSort=5
        PlaySound(4,#PB_Sound_MultiChannel)
      ElseIf KeyboardPushed(#PB_Key_L) And SpellKey=0
        SpellKey=2
        TimeSort=5
        PlaySound(4,#PB_Sound_MultiChannel)
      ElseIf KeyboardPushed(#PB_Key_M) And SpellKey=0
        SpellKey=3
        TimeSort=5
        PlaySound(4,#PB_Sound_MultiChannel)
      EndIf
    EndIf
    
    If SpellKey<>0 And TimeSort=5
      If Angle=-20 And Monstre(1)<>0
        If Sorts(SpellKey)=Monstre(1)+2
          Score+1
          Monstre(1)=0
          PlaySound(11);_________
        Else
          Vie-1
          Monstre(1)=0
        EndIf
      EndIf
      If Angle=0 And Monstre(2)<>0
        If Sorts(SpellKey)=Monstre(2)+2
          Score+1
          Monstre(2)=0
        Else
          Vie-1
          Monstre(2)=0
        EndIf
      EndIf
      If Angle=20 And Monstre(3)<>0
        If Sorts(SpellKey)=Monstre(3)+2
          Score+1
          Monstre(3)=0
        Else
          Vie-1
          Monstre(3)=0
        EndIf 
      EndIf
    EndIf
   
    ;-utilisation des spell
    If SpellKey<>0 And TimeSort>0 
      If Angle=-20 Or Angle=0 Or Angle=20
        If TimeSort>=4 Or TimeSort<=6
          DisplayTransparentSprite(Sorts(SpellKey)+4,PositionEffetSortX,PositionEffetSortY,230)
        EndIf
        If Monstre(1)<>0 Or Monstre(2)<>0 Or Monstre(3)<>0
          If TimeSort>=1 Or TimeSort<=3
            DisplayTransparentSprite(Sorts(SpellKey)+4,PositionEffetHitMonstreX,PositionEffetHitMonstreY,230)
          EndIf
        EndIf
      EndIf
      TimeSort-1
    EndIf
    
    If EnableJoystick
      If JoystickButton(0, 3)=0 And JoystickButton(0, 2)=0 And JoystickButton(0, 1)=0
        JoystickButtonPressed=0
        SpellKey=0
        TimeSort=0
      EndIf
    Else
      If KeyboardReleased(#PB_Key_K) Or KeyboardReleased(#PB_Key_L) Or KeyboardReleased(#PB_Key_M)
        SpellKey=0
        TimeSort=0
      EndIf
    EndIf
  ;-- getion pv/score/monstre
;     AffText("TempoPop:"+Str(TempoRepopMonstre(1)),800,70,255)
;     AffText("TempoPop:"+Str(TempoRepopMonstre(2)),800,100,255)
;     AffText("TempoPop:"+Str(TempoRepopMonstre(3)),800,130,255)
;     AffText("AffMonstre:"+Str(Monstre(1)),800,160,255)
;     AffText("AffMonstre:"+Str(Monstre(2)),800,190,255)
;     AffText("AffMonstre:"+Str(Monstre(3)),800,220,255)
;     AffText("LightM1:"+Str(Monstre(4)),800,250,255)
;     AffText("LightM2:"+Str(Monstre(5)),800,280,255)
;     AffText("LightM3:"+Str(Monstre(6)),800,310,255)
;     AffText("TimeSort:"+Str(TimeSort),800,310,255)
;     AffText("SpellKey:"+Str(SpellKey),800,340,255)

    ; Apparition des monstres
    If Monstre(1)<>0
      Monstre(4)+lightning
    EndIf
    If Monstre(2)<>0
      Monstre(5)+lightning
    EndIf
    If Monstre(3)<>0
      Monstre(6)+lightning
    EndIf
    
    If Monstre(4)>=255
      Monstre(1)=0
      Vie-1
    EndIf
    If Monstre(5)>=255
      Monstre(2)=0
      Vie-1
    EndIf
    If Monstre(6)>=255
      Monstre(3)=0
      Vie-1
    EndIf

    If Monstre(1)=0  
      Monstre(4)=0
      If TempoRepopMonstre(1)>=10
        TempoRepopMonstre(1)-1
      ElseIf TempoRepopMonstre(1)<10
        Monstre(1)=Random(3,1)
        TempoRepopMonstre(1)=Random(300,50)
      EndIf
    EndIf
    If Monstre(2)=0
      Monstre(5)=50
      If TempoRepopMonstre(2)>=10
        TempoRepopMonstre(2)-1
      ElseIf TempoRepopMonstre(2)<10
        Monstre(2)=Random(3,1)
        TempoRepopMonstre(2)=Random(300,50)
      EndIf
    EndIf
    If Monstre(3)=0
      Monstre(6)=50
      If TempoRepopMonstre(3)>=10
        TempoRepopMonstre(3)-1
      ElseIf TempoRepopMonstre(3)<10
        Monstre(3)=Random(3,1)
        TempoRepopMonstre(3)=Random(300,50)
      EndIf
    EndIf
    
  ;--Affiche gameOver bare de vie
    If Vie<=0 
     Flamme()
     DisplayTransparentSprite(38,1024/2-SpriteWidth(38)/2,768/2-SpriteHeight(38)/2,230)
     timerGameOver+1
     GameLaunch=0
     If timerGameOver<=5
       PlaySound(1,#PB_Sound_MultiChannel)
     EndIf
     If Vie<0 : Vie=0 :EndIf 
     If timerGameOver>200 
        Mode=0
        timerGameOver=0
      EndIf 
    EndIf

    For j=1 To Vie
      DisplaySprite(20,860+j*10,30)
    Next
    
    If TempoMonstreSpe>0
      TempoMonstreSpe-1
      DisplayTransparentSprite(14,0,0)
    EndIf
  EndProcedure
  
  Procedure Flamme() 
     ;-Affichage du feu et de la vie;  
     For j=0 To nbfeuMax
       For i=0 To 4
         flamWaitAnim(i)+1
         If flamWaitAnim(i)>10
           flamWaitAnim(i)=0
           flamAnim(i)+1
           If flamAnim(i)>4 :  flamAnim(i)=0 : EndIf    
         EndIf
         DisplayTransparentSprite(300+flamAnim(i),feuX(j),feuY(j),255)
       Next  
     Next 
  EndProcedure
  
;     Procedure etoile() 
;      ;-Affichage des etoile;  
;      For j=0 To nbetoileMax
;          etoileWaitAnim+1
;          If etoileWaitAnim>10
;            etoileWaitAnim=0
;            etoileAnim+1
;            If etoileAnim>7 :  etoileAnim=0 : EndIf       
;             DisplayTransparentSprite(600+etoileAnim,etoileX(j),etoileY(j),255)  
;          EndIf
;      Next 
;   EndProcedure

  Procedure AffText(Text$,x.i,y.i,light.i)
    For j=1 To Len(Text$)                              ; Fait une boucle sur le nombre de caractères à afficher
      a$=Mid(Text$,j,1)                                ; Prends un caractère après l'autre
      If (Asc(a$)>=Asc("!")) And (Asc(a$)<=Asc("z"))  ; vérifie que le caractère existe
        i.i=Asc(a$)-33                              ; rappel : le code Ascii de ! est 33
        DisplayTransparentSprite(i+200,x+j*16,y,light)         ; Affiche le sprite du caractere
      EndIf
    Next
  EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 394
; FirstLine = 374
; Folding = -
; EnableUnicode
; EnableXP