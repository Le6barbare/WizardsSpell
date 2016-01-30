;-
;-- Initialisation du systeme

;----- Librairies
  InitSprite()
  InitMouse()
  InitKeyboard()
  If InitJoystick()
    EnableJoystick = 1
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
  Global nbfeuMax=10, Vie, viePerdu,  FlamNum=1, timerGameOver


; Tableaux
  Global Dim Sorts(3), Dim PositionEffetSort(6)
  Global Dim flamAnim(4), Dim flamWaitAnim(4)
  Global Dim Monstre(6), Dim TempoRepopMonstre(3)

  Global Dim feuX(nbfeuMax),Dim feuY(nbfeuMax),Dim fireBool(nbfeuMax)
  
  
;- PROCEDURE
  Declare Menu()
  Declare GAME()
  Declare AffText(Text$,x.i,y.i,light.i)
  Declare Flamme()

;Ouvre un Screen Plein écran
  OpenScreen(1024, 768, 32, "")

;Clavier en mode International
  KeyboardMode(#PB_Keyboard_International)

;-Chargement Sound
;LoadSound(1,"Data/SoundPlasmaGFire.ogg")
;PlaySound(2)


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
  
   
  LoadImage(300,"Ressources/img/Animation/flamme2.png",#PB_Sprite_AlphaBlending)
  For j=0 To 4
    GrabImage(300,1,j*320/5,0, (j+1)*320/5,64)
    CreateSprite(300+j,320/5,64,#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(j+300))
    DrawImage(ImageID(1),0,0)
    StopDrawing()
    TransparentSpriteColor(j+300,RGB(0,0,0)) 
  Next

;- Creation de la bare du nb Vie
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

; initialisation
  Mode=0
  Score=0
  Sorts(1)= 3
  Sorts(2)= 4
  Sorts(3)= 5
  PositionEffetSortX=380
  PositionEffetSortY=565
  Monstre(1)=0;Random(3,1)
  Monstre(2)=0;Random(3,1)
  Monstre(3)=0;Random(3,1)
  Monstre(4)=0 ;Luminosité Monstre
  Monstre(5)=0 ;Luminosité Monstre
  Monstre(6)=0 ;Luminosité Monstre
  TempoRepopMonstre(1)=Random(300,50)
  TempoRepopMonstre(2)=Random(300,50)
  TempoRepopMonstre(3)=Random(300,50)
  Vie=10
  
  For i=0 To nbfeuMax
    feuX(i)=Random(840,640)
    feuY(i)=Random(670,580)
  Next

;-  *********************  
;--  START GAME LOOP
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
    If GameLaunch=0
      DisplaySprite(31,0,0)
      DisplayTransparentSprite(32,58,54)
      
      If KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q) Or KeyboardPushed(#PB_Key_S) Or KeyboardPushed(#PB_Key_D) Or KeyboardPushed(#PB_Key_Z)
        If TempoMenu<=5
          If SelectMenu=0 : SelectMenu=1 : Else : SelectMenu=0 : EndIf
          TempoMenu=50
        EndIf
      EndIf
      
      If TempoMenu>5
        TempoMenu-2
      EndIf
      
      If SelectMenu=0
        DisplayTransparentSprite(34,327,295)
        DisplayTransparentSprite(35,292,424)
      Else
        DisplayTransparentSprite(33,327,295)
        DisplayTransparentSprite(36,292,424)
      EndIf
      
      If KeyboardPushed(#PB_Key_Space) Or KeyboardPushed(#PB_Key_Return)
        If SelectMenu=0
          GameLaunch=1
        Else
          Quit=1
        EndIf
      EndIf
      
    ElseIf GameLaunch=1
      DisplaySprite(37,0,0)
      ;TempoStory=1000
      TempoStory-1
      ;AffText("TempoStory:" + Str(TempoStory),600,50,255)
      ;AffText("Espace/entrer pour commencer",100,675,255)
      If TempoStory<900
        If KeyboardPushed(#PB_Key_Space) Or KeyboardPushed(#PB_Key_Return) Or KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q) Or KeyboardPushed(#PB_Key_S) Or KeyboardPushed(#PB_Key_D) Or KeyboardPushed(#PB_Key_Z)  Or KeyboardPushed(#PB_Key_K) Or KeyboardPushed(#PB_Key_L) Or KeyboardPushed(#PB_Key_M)
          TempoStory=0
        EndIf
      EndIf
      If TempoStory<5
        Mode=1
        ;GameLaunch=0
      EndIf
      ;-- innitialisation partie
        Score=0
        Sorts(1)= 3
        Sorts(2)= 4
        Sorts(3)= 5
        Monstre(1)=Random(3,1)
        Monstre(2)=Random(3,1)
        Monstre(3)=Random(3,1)
        Monstre(4)=0
        Monstre(5)=0
        Monstre(6)=0
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
    DisplaySprite(1,0,0)
    
  ;--calcul trajectoire lune
    luneWait = luneWait + 1
    If luneWait>10
      If luneX.f<1024/2 : multi = multi + 1 : EndIf
      If luneX.f>1024/2 : multi = multi - 1 : EndIf
      If luneX.f>1024/2+200 : luneX.f=1024/2-200 : nbNuit+1 :

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

    EndIf
      luneX.f = luneX.f + multi/30
      luneWait=0
    EndIf
    luneY.f = initCentrLuneY-Sqr(200*200-(luneX.f-initCentrLuneX)*(luneX.f-initCentrLuneX)) 
    DisplayTransparentSprite(10,luneX,luneY,255)
    DisplayTransparentSprite(23,2,274,255)
    
  ;-info text interface
    AffText("Score : " + Str(Score),800-30,45,255)
    AffText("PV:" +Str(Vie),800-30,25,255)
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
      If KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_Q)
        DirectionKey=1
      ElseIf KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_D)
        DirectionKey=3
        Angle+10
      ElseIf KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_Z)
        DirectionKey=2
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
    ElseIf Angle=0 ; Baguette au centre
      PositionEffetSortX=385
      PositionEffetSortY=485
    ElseIf Angle=20 ; Baguette a droite
      Angle=20
      PositionEffetSortX=452
      PositionEffetSortY=497
    EndIf
    
    ; Rotation et affichage
    RotateSprite(6,Angle,0)
    DisplayTransparentSprite(6,300,600,255)
    
    ; Affichage Sort
    If KeyboardPushed(#PB_Key_K) And SpellKey=0
      SpellKey=1
      TimeSort=5
    ElseIf KeyboardPushed(#PB_Key_L) And SpellKey=0
      SpellKey=2
      TimeSort=5
    ElseIf KeyboardPushed(#PB_Key_M) And SpellKey=0
      SpellKey=3
      TimeSort=5
    EndIf
    
    If SpellKey<>0 And TimeSort=5
      If Angle=-20 And Monstre(1)<>0
        If Sorts(SpellKey)=Monstre(1)+2
          Score+1
          Monstre(1)=0
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
        DisplayTransparentSprite(Sorts(SpellKey)+4,PositionEffetSortX,PositionEffetSortY,230)
        TimeSort-1
      EndIf
    EndIf
    
    If KeyboardReleased(#PB_Key_K) Or KeyboardReleased(#PB_Key_L) Or KeyboardReleased(#PB_Key_M)
      SpellKey=0
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

    If Monstre(1)<>0
      Monstre(4)+1
    EndIf
    If Monstre(2)<>0
      Monstre(5)+1
    EndIf
    If Monstre(3)<>0
      Monstre(6)+1
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
      Monstre(5)=0
      If TempoRepopMonstre(2)>=10
        TempoRepopMonstre(2)-1
      ElseIf TempoRepopMonstre(2)<10
        Monstre(2)=Random(3,1)
        TempoRepopMonstre(2)=Random(300,50)
      EndIf
    EndIf
    If Monstre(3)=0
      Monstre(6)=0
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
     If timerGameOver>200 
        Mode=0
        timerGameOver=0
     EndIf 
    EndIf

     For j=1 To Vie
       DisplaySprite(20,860+j*10,30)
     Next
;     
;     AffText(Str(MouseX()),100,500,255)
;     AffText(Str(MouseY()),100,600,255)
; 
;     DisplayTransparentSprite(23,MouseX(),MouseY(),255)

  EndProcedure
  
  Procedure Flamme() 
     ;-Affichage du feu et de la vie;  
     For j=0 To nbfeuMax
       For i=0 To 4
         flamWaitAnim(i)+1
         If flamWaitAnim(i)>5
           flamWaitAnim(i)=0
           flamAnim(i)+1
           If flamAnim(i)>4 :  flamAnim(i)=0 : EndIf    
         EndIf
         DisplayTransparentSprite(300+flamAnim(i),feuX(j),feuY(j),255)
       Next  
     Next 
  EndProcedure

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
; CursorPosition = 190
; FirstLine = 172
; Folding = -
; EnableUnicode
; EnableXP