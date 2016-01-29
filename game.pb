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


;----- declare variable 

;- VARIABLES

;- Procedures
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
;LoadSprite(1,"Ressources/img/space2.png",#PB_Sprite_AlphaBlending)
;TransparentSpriteColor(2, RGB(255, 0, 255)) 

;-Creation sprite
;-Chargement texte
  LoadImage(200,"Ressources/img/Font.bmp")              ; Charge l'image de toutes les lettres
  For j=0 To 125-33                               ; Fait une boucle de toutes les lettres
    GrabImage(200,j,j*16,0,j*16+16,16)            ; Découpe lettre par lettre
    CreateSprite(j+200,16,16)  ; Crée un sprite pour chaque lettre
    StartDrawing(SpriteOutput(j+200))
      DrawImage(ImageID(j),0,0)                   ; Place la lettre découpée dans le sprite
      StopDrawing()
  Next



; initialisation
  Mode=1
  
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
; CursorPosition = 41
; FirstLine = 24
; Folding = -
; EnableUnicode
; EnableXP