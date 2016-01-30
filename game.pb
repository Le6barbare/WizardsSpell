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
  Global i,j,Angle=0,DirectionKey=0
  
; Tableau
  Global Dim luneAnim(21), Dim lunewaitAnim(21)
  Global Dim Sorts(3), Dim PositionEffetSort(6)
  Global Dim  flamAnim(4), Dim flamWaitAnim(4)
  
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
LoadSprite(1,"Ressources/img/background.png")
LoadSprite(2,"Ressources/img/spells.png")
LoadSprite(3,"Ressources/img/spellred.png")
LoadSprite(4,"Ressources/img/spellgreen.png")
LoadSprite(5,"Ressources/img/spellwhite.png")
LoadSprite(6,"Ressources/img/baguette.png",#PB_Sprite_AlphaBlending)
LoadSprite(7,"Ressources/img/Sort/sort-rouge.png",#PB_Sprite_AlphaBlending)
LoadSprite(8,"Ressources/img/Sort/sort-vert.png",#PB_Sprite_AlphaBlending)
LoadSprite(9,"Ressources/img/Sort/sort-blanc.png",#PB_Sprite_AlphaBlending)
 
LoadImage(300,"Ressources/img/Animation/flamme2.png",#PB_Sprite_AlphaBlending)
For j=0 To 4
  GrabImage(300,1,j*320/5,0, (j+1)*320/5,65)    
  CreateSprite(300+j,320/5,65,#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(j+300))   
    DrawImage(ImageID(1),0,0)
    StopDrawing()
    ;TransparentSpriteColor(j+300,RGB(0,0,0)) 
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
  Sorts(1)=3 ;ROUGE
  Sorts(2)=4 ;VERT
  Sorts(3)=5 ;BLANC
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
    DisplaySprite(2,0,0)
    
    DisplaySprite(Sorts(1),2,2)
    DisplaySprite(Sorts(2),78,2)
    DisplaySprite(Sorts(3),154,2)
    
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
    
    If Angle=0
      PositionEffetSortX=450
      PositionEffetSortY=555
    ElseIf Angle=20
      Angle=20
      PositionEffetSortX=515
      PositionEffetSortY=565
    ElseIf Angle=-20
      Angle=-20
      PositionEffetSortX=385
      PositionEffetSortY=565
    EndIf
    
    RotateSprite(6,Angle,0)
    DisplayTransparentSprite(6,300,600,255)
    
    If KeyboardPushed(#PB_Key_K)
      DisplayTransparentSprite(Sorts(1)+4,PositionEffetSortX,PositionEffetSortY,230)
    ElseIf KeyboardPushed(#PB_Key_L)
      DisplayTransparentSprite(Sorts(2)+4,PositionEffetSortX,PositionEffetSortY,230)
    ElseIf KeyboardPushed(#PB_Key_M)
      DisplayTransparentSprite(Sorts(3)+4,PositionEffetSortX,PositionEffetSortY,230)
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
; CursorPosition = 60
; FirstLine = 81
; Folding = -
; EnableUnicode
; EnableXP