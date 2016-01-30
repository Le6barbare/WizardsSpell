;-
;-- Initialisation du systeme

;----- Librairies
  InitSprite()
  InitMouse()
  InitKeyboard()
  InitSound()

;----- Décodeur des formats images
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  UseOGGSoundDecoder() 

;----- VARIABLES
  Global i,j,Angle=0,DirectionKey=0,SpellKey=0,TimeSort=3
  Global tirage, precedant1, precedant2
  
; Tableau
  Global Dim Sorts(3), Dim PositionEffetSort(6)
  Global Dim flamAnim(4), Dim flamWaitAnim(4)
  Global luneWait=0, luneX.f=1024/2-200, luneY.f=0, initCentrLuneX=1024/2, initCentrLuneY=250, multi, nbnuit = 1
  Global nuage1.f=Random(1024), nuage2.f=Random(1024), nuage3.f=Random(1024), nuage4.f=Random(1024), nuage5.f=Random(1024)
  
;- PROCEDURE
  Declare Menu()
  Declare GAME()
  Declare AffText(Text$,x.i,y.i,light.i)

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
LoadSprite(6,"Ressources/img/baguette.png",#PB_Sprite_AlphaBlending)
LoadSprite(7,"Ressources/img/Sort/sort-rouge.png",#PB_Sprite_AlphaBlending)
LoadSprite(8,"Ressources/img/Sort/sort-vert.png",#PB_Sprite_AlphaBlending)
LoadSprite(9,"Ressources/img/Sort/sort-blanc.png",#PB_Sprite_AlphaBlending)
LoadSprite(10,"Ressources/img/Lune/lune0.png",#PB_Sprite_AlphaBlending)
LoadSprite(21,"Ressources/img/Animation/nuage1.png",#PB_Sprite_AlphaBlending)
LoadSprite(22,"Ressources/img/Animation/nuage2.png",#PB_Sprite_AlphaBlending)
LoadSprite(23,"Ressources/img/Animation/montage-eau.png",#PB_Sprite_AlphaBlending)
 
LoadImage(300,"Ressources/img/Animation/flamme2.png",#PB_Sprite_AlphaBlending)
For j=0 To 4
  GrabImage(300,1,j*320/5,0, (j+1)*320/5,64)    
  CreateSprite(300+j,320/5,64,#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(j+300))   
    DrawImage(ImageID(1),0,0)
    StopDrawing()
    TransparentSpriteColor(j+300,RGB(0,0,0)) 
   Next



;- Chargement Font
  LoadImage(200,"Ressources/img/Font.bmp")              ; Charge l'image de toutes les lettres
  For j=0 To 125-33                               ; Fait une boucle de toutes les lettres
    GrabImage(200,j,j*16,0,j*16+16,16)            ; Découpe lettre par lettre
    CreateSprite(j+200,16,16)                     ; Crée un sprite pour chaque lettre
    StartDrawing(SpriteOutput(j+200))
      DrawImage(ImageID(j),0,0)                   ; Place la lettre découpée dans le sprite
      StopDrawing()
  Next

; initialisation
  Mode=1
  
  Sorts(1)= 3
  Sorts(2)= 4
  Sorts(3)= 5
 
  
  PositionEffetSortX=380
  PositionEffetSortY=565
  
;-  *********************  
;--  START GAME LOOP
;- 
  Repeat
    ExamineKeyboard()
    ExamineMouse()
   
    If Mode=0: Menu():EndIf
    If Mode=1: GAME():EndIf
  
    FlipBuffers()
    Until KeyboardPushed(#PB_Key_Escape) Or Quitte = 1
  End
;- 
;--  END GAME LOOP
;-  *********************


;- PROCEDURES

  Procedure GAME()
  
    DisplaySprite(1,0,0)
     DisplayTransparentSprite(2,0,0)
 
    ;-- Gestion de la baguette
    If DirectionKey=0
      If KeyboardPushed(#PB_Key_Left)
        DirectionKey=1
      ElseIf KeyboardPushed(#PB_Key_Right)
        DirectionKey=3
        Angle+10
      ElseIf KeyboardPushed(#PB_Key_Up)
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
    
    For j=0 To 4
      flamWaitAnim(j)+1
      If flamWaitAnim(j)>5
        flamWaitAnim(j)=0
        flamAnim(j)+1
        If flamAnim(j)>4 :  flamAnim(j)=0 : EndIf
      EndIf
      DisplayTransparentSprite(300+flamAnim(j),200,400,255)  
    Next 
    
    
    
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
    
    
    
    
    
  ;-- calcul nb nuit
  
  AffText("Nuit "+ Str(nbNuit),815,5,255)
    
    
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
  
  ;-- affichage des grimoires
    DisplayTransparentSprite(Sorts(1),2,2)
    DisplayTransparentSprite(Sorts(2),110,2)
    DisplayTransparentSprite(Sorts(3),210,2)
    
  EndProcedure

  Procedure Menu()
    
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
; CursorPosition = 44
; FirstLine = 37
; Folding = -
; EnableUnicode
; EnableXP