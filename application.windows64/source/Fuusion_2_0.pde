import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//VARIABLES

//Detection des touches
int haut ;
int bas ;
int gauche ;
int droite ;
boolean touche_haut_relache = true;

//Souris
int souris = 0;
boolean souris_relache = true;

//Collisions
int collision_b ;
int collision_h ;
int collision_d ;
int collision_g ;

//Nuages

float xn1 = 1650;       //variables utilisées pour l'affiche des nuages
float xn2 = 800;
float yn1 = 50;
float yn2 = 60;
float vent;

//Chrono
PFont chrono;
int fps = 0;
int sec = 0;
int min = 0;

//Bobby
int x = 200 ;            //coordonnées de Bobby
float y = 400;
int saut ;               // flag permettant de savoit si bobby est en saut ou pas
int vitesse_saut = 12 ;
int nombre_sauts = 2 ;
int vitesse = 10;
float grav_abs = 0.9 ;
float vitesseY = 10;
float gravite ;
int nombre_morts = 0;
int taille_bobby = 50 ;
PFont nb_morts;

//Selection de la couleur de Bobby
int x_coul = 0;
int couleur_bobby = 1;
int y_coul = -1497;


//Niveaux
int longueur_niveau = 4800 ;
int hauteur_niveau = 900 ;
int xi = 0;     //coordonnées en x de l'image de fond
int [][] matrice = new int [12000] [900];
int ID_sol = 10 ;
int ID_pic = 2 ;
int niv;
int nb_fleurs_max;

// Code_triche
int etape = 0 ;
int temps = 0 ;

//Menus
int yc = 0;
int chronologie = 0;     //cette variable nous permet de définir plusieurs phases dans notre programme [voir void draw()]

//intro
int chrono_intro = 0;
int y_histoire = 0;

//Images
PImage bobby;            //Chaque variable PImage correspond à une image
PImage niveau;
PImage menu1;
PImage menu2;
PImage quitter1;
PImage quitter2;
PImage bcommandes1;
PImage bcommandes2;
PImage commandes;
PImage commandesretour;
PImage defilement;
PImage defilement2;
PImage nuage1;
PImage nuage2;
PImage pause;
PImage pause_bouton_recommencer;
PImage pause_bouton_reprendre;
PImage pause_bouton_menu;
PImage menu_victoire;
PImage yeux;
PImage choix_niveau;
PImage choix_couleur;
PImage coming_soon;
PImage image_belier;
PImage histoire;              //declarer l'histoire
PImage bobby_mort;

int score = 0;
PFont nb_fleurs;
Fleur f1_1 = new Fleur(950,500) ;
Fleur f1_2 = new Fleur(1450,600) ;
Fleur f1_3 = new Fleur(1600,600) ;
Fleur f1_4 = new Fleur(2350,600) ;
Fleur f1_5 = new Fleur(2500,550) ;
Fleur f1_6 = new Fleur(2750,400) ;
Fleur f1_7 = new Fleur(3100,300) ;
Fleur f1_8 = new Fleur(3150,350) ;
Fleur f1_9 = new Fleur(3200,400) ;


Minim minim;
AudioPlayer mus_menu;
AudioPlayer mus_jeu;


void setup(){
  size(1600,900);                               //initialisation de la taille de la fenetre
  

  menu1 = loadImage("play1.jpg");                //loadImage(" ") permet d'aller chercher une image portant le nom demandé dans le dossier où est présent le fichier processing
  menu2 = loadImage("play2.jpg");
  quitter1 = loadImage("quitte1.png");
  quitter2 = loadImage("quitte2.png");
  bcommandes1 = loadImage("commandes1.png");
  bcommandes2 = loadImage("commandes2.png");
  commandes = loadImage("commandes.jpg");
  commandesretour = loadImage("commandesr.jpg");
  defilement = loadImage("defilement.png");
  defilement2 = loadImage("defilement2.png");
  nuage1 = loadImage("nuage 1.png");
  nuage2 = loadImage("nuage 2.png");
  pause = loadImage("pause.jpg");
  pause_bouton_recommencer = loadImage("pause - recommencer.jpg");
  pause_bouton_reprendre = loadImage("pause - reprendre.jpg");
  pause_bouton_menu = loadImage("pause - menu.jpg");
  menu_victoire = loadImage("victoire.jpg");
  yeux = loadImage("yeux bas droite.png");
  choix_niveau = loadImage("choix niveau 1.png");
  choix_couleur = loadImage("defilement couleurs.png");
  coming_soon = loadImage("coming soon.jpg");
  bobby_mort = loadImage("bobby mort.png");
  frameRate(60) ;                       //initialisation du nombre d'images par secondes
  
  
  
  chrono = createFont("Century Gothic",16,true);
  nb_morts = createFont("Century Gothic",16,true);
  nb_fleurs = createFont("Century Gothic",16,true);
  
  minim = new Minim(this);
  mus_menu = minim.loadFile("Menu.mp3") ;
  mus_jeu = minim.loadFile("ingame.mp3") ;
}






class Fleur {
  int x_pos, y_pos ;
  int pick ;
  int couleur ;
  PImage img_fleur ;
  int temps;
  int tourne ;
  int ancien_nombre_morts ;
   Fleur (int x, int y) {
   x_pos = x ;
   y_pos = y ;
   pick = 0 ;
   tourne = 1 ;
   temps = 0;
   couleur = (int) random(1, 11) ;
   ancien_nombre_morts = 0 ;
   
   }
   
   
   void maj () {
     if (ancien_nombre_morts != nombre_morts) {
      pick = 0 ; 
      couleur = (int) random(1, 11) ;
     }
     temps ++ ;
     temps = (temps > 59) ? 0 : temps ;
     tourne = (temps > 29) ? 2 : 1;
     int distance = (int)sqrt(pow(x_pos + xi - x,2)+pow(y_pos - y,2));
    
     if (pick == 0 && distance < 30) {
       pick = 1 ;
       score = score + 1 ;
     }else if (pick == 0) {
       img_fleur = loadImage ("fleur " + couleur + " " + tourne + ".png");
       image(img_fleur, x_pos + xi, y_pos) ;

     }
     ancien_nombre_morts = nombre_morts ;
   }
}


void draw(){

  switch(chronologie){               //cette fonction permet de choisir ce que l'on veut faire en fonction de la valeur de la variable chronologie
   default:    //Dans le cas par defaut
    cursor(ARROW);
    menu();                          //on affiche le menu   (appel de la fonction menu)
    break;
    
   case -1 :                     //intro
   // intro();
    break;
   
   case 1 :
    MenuNiveauCouleur(); //Choix de la couleur et du niveau
    break;
    
   case 2 :
    background(coming_soon);
    if(souris == 1 && mouseButton == LEFT && souris_relache == true){
    chronologie = 1;
    souris_relache = false;
    }
    break;
   
   case 3:                           
    cursor(ARROW);
    menu_commandes();
    break;
    
   case 4 :
    cursor(ARROW);
    pause();
    break;
    
   case 5 :
    cursor(ARROW);
    victoire();
    break;
    
   case 6 :
    //rien
    break;
   
   case 7 :                      
    init_niv1(); 
    break; 
    
   case 8 :                   
    gestion_niveau() ;                  
    niveau_1();
    break;
  
  case 9 :
   init_niv2();
   break;
   
   case 10 :
   gestion_niveau() ;
   niveau_2();
    break;
  }
  
  //gestion_musique() ;
  /*print("la");
  if ( mus_menu.isPlaying() == false){
       mus_menu.loop(1);
    }*/
    
    if (chronologie < 7) {
    mus_jeu.pause();
   if ( mus_menu.isPlaying() == false){
       mus_menu.loop(1);
    }
    }else {
      mus_menu.pause();
   if ( mus_jeu.isPlaying() == false){
       mus_jeu.loop(1);
       }
     }
    
}










void menu(){
  
  color coul_souris = get(mouseX,mouseY);
  float vert_souris = green(coul_souris);
  
 background(menu1);                                                      //affichage de l'image de fond
 if(mouseX>599 && mouseX<1000 && mouseY>346 && mouseY<746 && vert_souris != 117){              //Si la souris est dans le grand carré du milieu
  background(menu2);                                                     //alors l'image de fond change pour donner l'impression que le bouton est enfoncé
  if(souris == 1 && mouseButton==LEFT && souris_relache == true){                           //Et si on clique sur le bouton gauche de la souris
   chronologie = 1;                                                      //Alors la variable chronologie prend la valeur 1
   souris_relache = false; 
  } 
 }
 
 image(quitter1,300,346);                                                //Affichage de l'image du bouton "quitter"
 if(mouseX>300 && mouseX<500 && mouseY>346 && mouseY<746 && vert_souris != 117){               //Si la souris passe par dessus
  image(quitter2,300,346);                                               //Alors on change l'image pour donner l'impression qu'il est enfoncé
  if(souris == 1 && mouseButton==LEFT && souris_relache == true){                           //Et si on clique sur le bouton gauche de la souris
   exit();                                                               //Alors on ferme le programme
   souris_relache = false;
  } 
 }
 
 image(bcommandes1,1100,346);                                            //Affichage de l'image du bouton "commandes"
 if(mouseX>1100 && mouseX<1300 && mouseY>346 && mouseY<746 && vert_souris != 117){             //Si la souris passe par dessus
  image(bcommandes2,1100,346);                                           //Alors on change l'image pour donner l'impression qu'il est enfoncé
  if(souris == 1 && mouseButton == LEFT && souris_relache == true){                        //Et si on clique sur le bouton gauche de la souris
   chronologie = 3;                                                      //Alors la variable chronologie prend la valeur 2
   souris_relache = false;
  }
 }
}








void menu_commandes(){  
  
  color coul_souris = get(mouseX,mouseY);
  float vert_souris = green(coul_souris);

  background(0,117,232);                                               //Définition de la couleur du fond en bleu ciel
  image(commandes,0,yc);                                               //Affichage de l'image
  
  if(yc == 0){                                                         //Si l'image est en haut
   if(mouseX>13 && mouseX<176 && mouseY>15 && mouseY<67 && vert_souris != 117){             //Et si a souris pas au dessus du bouton "retour"
    image(commandesretour,0,yc);                                       //Alors on change l'image pour donner l'impression qu'il est enfoncé
     if(souris == 1 && mouseButton == LEFT && souris_relache == true){                   //Et si on clique sur le bouton gauche de la souris
      chronologie = 0;                                                  //Alors la variable chronologie prend la valeur 0 (retour au menu de base)
      souris_relache = false;
     }
   }
  }
  
  
  if(mouseY>847){                    //Si la souris est sur le bandeau transparent du bas de l'ecran
    yc = yc - 8;                     //Alors l'image descend
  }
  
  if(yc>-17990){                     //Si l'image est en haut
    image(defilement,0,0);           //Alors on affiche un ruban transparent en bas
  }
  
  if(yc < 0){                        //Si l'image n'est pas en haut
   image(defilement2,0,0);           //Alors on affiche un ruban en haut pour donner la possibilité de remonter
   if(mouseY<53){                    //Et si la souris passe dessus
    yc = yc + 8;                     //Alors l'image remonte
   } 
  }
}








void MenuNiveauCouleur(){
  
color coul_souris = get(mouseX,mouseY);
float vert_souris = green(coul_souris);

if(mouseX>13 && mouseX<177 && mouseY>15 && mouseY<78 && vert_souris != 117){     //Si la souris est sur le bouton Retour
  choix_niveau = loadImage("choix niveau 2.png");                                //Alors on change l'affichage pour donner l'impression que le bouton est enfoncé
  if(souris == 1 && souris_relache == true){                                       //Et si l'on clique
   chronologie = 0;                                                                //Alors on retourne au menu de départ
  }
} else{                                                                          //Sinon
  choix_niveau = loadImage("choix niveau 1.png");                                //On affiche l'image normale
}
  
 background(0,64,128);                //couleur bleu que l'on voit derriere bobby sur la gauche
 image(choix_couleur,68,y_coul);      //Image des differentes couleurs de Bobby les unes au dessus des autres
 image(choix_niveau,0,0);             //Image du choix des niveaux

 
 
 
 if(mouseX>165 && mouseX<266 && mouseY>175 && mouseY<266 && vert_souris != 117){     //Si la souris est dans un carré correspondant à l'emplacement de la fleche du haut et que la couleur sous la souris n'est pas bleu
   if(souris == 1 && souris_relache == true){                                        //Si on appuie sur la souris
     couleur_bobby ++;                                                               //La variable qui definit la couleur de bobby est augmentee de 1
     y_coul = y_coul + 300;                                                          //On change la couleur du Bobby affiche dans le menu
     souris_relache = false;
   }
 }
 
 if(mouseX>165 && mouseX<266 && mouseY>640 && mouseY<731 && vert_souris != 117){    //Si la souris est dans un carré correspondant à l'emplacement de la fleche du bas et que la couleur sous la souris n'est pas bleu
   if(souris == 1 && souris_relache == true){                                       //Si on appuie sur la souris
     couleur_bobby --;                                                              //La variable qui definit la couleur de bobby est diminuee de 1
     y_coul = y_coul - 300;                                                         //On change la couleur du Bobby affiche dans le menu
     souris_relache = false;
   }
 }
 
 
 
 if(mouseX>656 && mouseX<766 && mouseY>203 && mouseY<313){     //niveau 1     //Si la soursi est sur le bouton "1"
  if(souris == 1 && souris_relache == true){                                    //Et si l'on clique
   chronologie = 7;                                                             //Alors on lance l'initialisation du niveau 1
   souris_relache = false;
  } 
 }
 
 if(mouseX>984 && mouseX<1095 && mouseY>203 && mouseY<313){     //niveau 2
  if(souris == 1 && souris_relache == true){
   chronologie = 9;
   souris_relache = false;
  } 
 }
 
 if(mouseX>1302 && mouseX<1413 && mouseY>203 && mouseY<313){     //niveau 3
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>656 && mouseX<766 && mouseY>371 && mouseY<482){     //niveau 4
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>984 && mouseX<1095 && mouseY>371 && mouseY<482){     //niveau 5
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>1302 && mouseX<1413 && mouseY>371 && mouseY<482){     //niveau 6
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>656 && mouseX<766 && mouseY>538 && mouseY<649){     //niveau 7
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>984 && mouseX<1095 && mouseY>538 && mouseY<649){     //niveau 8
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>1302 && mouseX<1413 && mouseY>538 && mouseY<649){     //niveau 9
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>656 && mouseX<766 && mouseY>707 && mouseY<818){     //niveau 10
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(mouseX>984 && mouseX<1095 && mouseY>707 && mouseY<818){     //niveau11
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 if(mouseX>1302 && mouseX<1413 && mouseY>707 && mouseY<818){     //niveau 12
  if(souris == 1 && souris_relache == true){
   chronologie = 2;
   souris_relache = false;
  } 
 }
 
 if(y_coul > 305){            //Si on arrive a la couleur du haut de l'image (cyan) et que l'on appuie sur la fleche du haut
   y_coul = -1497;            //Alors on chnage la coordonnee de cette image pour revenir en bas
 }
 if(y_coul<-1500){            //Si on arrive a la couleur du haut de l'image (cyan) et que l'on appuie sur la fleche du bas
   y_coul = 303;              //Alors on chnage la coordonnee de cette image pour revenir en haut
 }
 if(couleur_bobby>7){         //On realise la meme action pour la variable de la couleur
   couleur_bobby = 1;         //*
 }
 if(couleur_bobby<1){         //*
   couleur_bobby = 7;         //*
 }
}


void gestion_musique () {
 /*if (chronologie < 7) {
    mus_jeu.close();
   if ( mus_menu.isPlaying() == false){*/
       mus_menu.loop(1);
    /*} else {
      mus_menu.close();
   if ( mus_jeu.isPlaying() == false){
       mus_jeu.loop(10);
       }
     }
    }*/  
}



void pause(){
  background(pause);                                                                    //Affichage du menu pause
  
  if(mouseX>146 && mouseX<546 && mouseY>487 && mouseY<687 && souris_relache == true){                 //RECOMMENCER        //Si la souris est sur le bouton Recommencer
    background(pause_bouton_recommencer);                                                                                  //Alors on change l'affichage
    if(souris == 1 && mouseButton == LEFT){                                                                                //Si on clique
     chronologie = niv - 1;                                                                                                //Alors on lance l'initialisation du niveau
     nombre_morts = 0;
    }
  
   
 }
  
   if(mouseX>600 && mouseX<1000 && mouseY>487 && mouseY<687 && souris_relache == true){                 //REPRENDRE         //Si on clique avec le bouton gauche
    background(pause_bouton_reprendre);
    if(souris == 1 && mouseButton == LEFT){                         //Sur le bouton reprendre
     chronologie = niv;                                                                   //Alors on reprend le niveau sans tout reinitialiser
    }
  }
  
   if(mouseX>1059 && mouseX<1459 && mouseY>487 && mouseY<687 && souris_relache == true){                 //MENU              //Si on clique avec le bouton gauche
   background(pause_bouton_menu);
    if(souris == 1 && mouseButton == LEFT){                        //Sur le bouton menu
     chronologie = 0;     //Alors on lance le menu
     souris_relache = false;
     }
  }
}






void victoire(){
  background(menu_victoire);
 
  String nombre_m = nombre_morts+" " ;
  textFont(nb_morts,48);
  fill(255);
  text(nombre_m,848,548);
  
  String nombre_f = score+"/"+nb_fleurs_max;
  textFont(nb_fleurs,48);
  fill(255);
  text(nombre_f,825,432);
  
  String chronometre = ""+min+" : "+sec;     
  textFont(chrono,48);                         
  fill(255);                                 
  text(chronometre,840,318);
  
  if(mouseX>142 && mouseX<543 && mouseY>619 && mouseY<820){        //MENU
    if(souris == 1 && mouseButton == LEFT){
    chronologie = 1;           //Menu choix niveau/couleur
    }
  }
  
  if(mouseX>604 && mouseX<997 && mouseY>619 && mouseY<820){        //RECOMMENCER
    if(souris == 1 && mouseButton == LEFT){
    chronologie = niv - 1;     //Initialisation du niveau
    }
  }
  
  if(mouseX>1055 && mouseX<1456 && mouseY>619 && mouseY<820){        //SUIVANT
   if(souris == 1 && mouseButton == LEFT){
    chronologie = niv + 1;     //Initialisation du niveau suivant
   }
  }
}






void keyPressed() {
 if(keyCode== UP) {
 haut = 1 ;
 }
 if(keyCode==DOWN) {
  bas = 1 ; 
 }
 if(keyCode== LEFT) {
 gauche = 1 ;
 }
 if(keyCode==RIGHT) {
 droite = 1 ; 
 }
}

void keyReleased() {
  if(keyCode== UP) {
 haut = 0 ;
 touche_haut_relache = true ;
 }
 if(keyCode==DOWN) {
  bas = 0 ; 
 }
 if(keyCode== LEFT) {
 gauche = 0 ;
 }
 if(keyCode==RIGHT) {
 droite = 0 ; 
 }
}

void mousePressed(){
 souris = 1; 
}

void mouseReleased(){
 souris = 0; 
 souris_relache = true;
}








void gestionbobby() {
  saut_gravite() ;
  collision_droite() ;
  collision_gauche() ;
  
  vitesse = 10;
 
 if(droite ==1 && collision_d == 0){                 //Si on appuie sur la fleche de droite et qu'il n'y a pas d'obstacles
  if(x<=700 ){                    //Et si bobby est dans la partie gauche de la fenetre
   x = x + vitesse;              //Alors il avance
  }
  
  if(x>700 && x+50<=1600-5){     //Si bobby est dans la partie droite de la fenetre
   if(xi <= -(longueur_niveau-1605)){      //Et si le decors est arrivé au bout à droite
    x = x + vitesse;             //Alors bobby avance
   } else{                       //Sinon
      xi = xi - vitesse;         //Le decors recule pour donner l'impression que bobby avance
     }
  }
 }
 
 if(gauche == 1 && collision_g == 0){                // * Si on appuie sur la fleche de gauche et qu'il n'y a pas d'obstacles
  if(xi>=0){                     // ** Et si le decors est au bout à gauche
   x = x - vitesse;              //    Alors bobby recule
   if(x<=-1){                    // *** Et si bobby est au bout a gauche de la fenetre
    x = x + vitesse;             //    Alors il s'arrete (equilibrage des forces)
   }
  }
  if(xi<0 && xi >-(longueur_niveau-1605)){ // ** Et si le decor n'est ni au bout à droite ni au bout à gauche
   xi = xi + vitesse;            //    Alors il bouge
  }
  
  if(xi <= -(longueur_niveau-1605)){       // ** Et si le decor est arrivé au bout à droite
    if(x>700){                   // *** Et si bobby est au milieu de l'ecran
     x = x - vitesse;            //     Alors bobby recule
    } else{                      //     Sinon
     xi = xi + vitesse;          //     Le decor avance
    } 
  }
  
  x = constrain(x,0,1600);
  
 }
  
 switch(couleur_bobby){                           //Selon la valeur de la variable "couleur_bobby", on affecte a la variable PImage "bobby" differentes images
   case 1 :
    bobby = loadImage("bleu.png");
    break;
    
   case 2 :
    bobby = loadImage("rouge.png");
    break;
    
   case 3 :
    bobby = loadImage("jaune.png");
    break;
    
   case 4 :
    bobby = loadImage("vert.png");
    break;
    
   case 5 :
    bobby = loadImage("orange.png");
    break;
    
   case 6 :
    bobby = loadImage("violet.png");
    break;
    
   case 7 :
    bobby = loadImage("cyan.png");
    break;
    
   case 8 :
    bobby = loadImage("arc en ciel.png");
    break;
 }
 
 image(niveau,xi,0);        //Affichage du niveau
 image(bobby,x,y);              //Affichage de bobby
 
 gestion_yeux();
}
 
 
 
 
 
 
 
 
 void gestion_yeux(){                                   //Selon la touche qui est enfoncée, les yeux regardent dans cette direction
   if(bas == 1) {
    yeux = loadImage("yeux milieu bas.png") ; 
   }
   if(droite == 1){
     yeux = loadImage("yeux bas droite.png");
     if(haut == 1){
       yeux = loadImage("yeux haut droite.png");
     }
   }
   if(gauche == 1){
     yeux = loadImage("yeux bas gauche.png");
     if(haut == 1){
       yeux = loadImage("yeux haut gauche.png");
     }
   }
   if(haut == 1 && droite == 0 && gauche == 0){
     yeux = loadImage("yeux milieu haut.png");
   }
   
   
   image(yeux,x,y);                                   //Affichage des yeux
 }
 
 
 
 
 
 
 
 
 
 void saut_gravite () {
  collision_bas() ;
  collision_haut () ;
  
  if (collision_b == 0) {   // Si collision en bas
    gravite = grav_abs ;
  } else {
    saut = 0 ;
    gravite = 0 ;
    vitesseY = 0 ;
  }
  if (haut == 1 && saut < nombre_sauts && touche_haut_relache) {
   vitesseY = vitesse_saut ; 
   touche_haut_relache = false ;
  saut ++  ; 
  }
  vitesseY = constrain(vitesseY - gravite, - 10 , 20 ) ;
  y = y - vitesseY ;
}













 
 void collision_bas() {
  int collision_bd ;   //collision en bas a droite
  
  collision_b = matrice [(int)x - xi] [constrain((int)(y + 49 - vitesseY - gravite), 1, 899)] ;
  collision_bd = matrice [(int)x - xi + 49] [constrain((int)(y + 49 - vitesseY - gravite), 1, 899)] ;
  
  
  if (collision_b < collision_bd) {
   collision_b = collision_bd ; 
  }  
}
 
 void collision_haut() {
  int collision_hd ;   //collision en haut à droite
  
  collision_h = matrice [(int)x - xi] [constrain((int)(y - vitesseY + gravite), 1, 899)] ;
  collision_hd = matrice [(int)x - xi + 49] [constrain((int)(y - vitesseY + gravite), 1, 899)] ;
  
  if (collision_h < collision_hd) {
   collision_h = collision_hd ; 
  }
  
  if (collision_h == 10) {
   vitesseY = 0 ; 
  }
}

void collision_droite() {
 int collision_db ;

 collision_d = matrice [(int)x - xi + 49 + vitesse] [constrain((int)y, 1, 899)] ;
 collision_db = matrice [(int)x - xi + 49 + vitesse] [constrain((int)(y + 47), 1, 899)] ;
 
 if (collision_d < collision_db) {
  collision_d = collision_db ; 
 }
}


void collision_gauche() {
 int collision_gb ;

 collision_g = matrice [constrain((int)x - xi - vitesse,0,999999999)] [constrain((int)y, 1, 899)] ;
 collision_gb = matrice [constrain((int)x - xi - vitesse,0,999999999)] [constrain((int)(y + 47), 1, 899)] ;
 
 if (collision_g < collision_gb) {
  collision_g = collision_gb ; 
 }
}










void plateforme_matrice (int x_ini, int y_ini, int longueur, int hauteur) {          // longueur et hauteur en bloc
  int j ;                                                                            // pixel en haut à gauche
  int i ;
  
  for (i = 0 ; i < 50 * longueur ; i++ ){
    for (j = 0 ; j < 50 * hauteur ; j++ ){
     matrice [x_ini + i] [y_ini + j] = ID_sol ; 
    }
  }
}
 
 
void matrice_pic (int x_ini, int y_ini, int longueur) {    // longueur des pic en bloc de 50x50                    // Créer les pics dans la matrice  ----  /!\ Les coordonnées des pics sont ceux en bas à gauche !!!!!!!!!!!!!!!!!!!!!!!!!!!
  int i ;                                                          
  int j ;                                               //             pics "reels"            pics dans la matrice pour
                                                        //             22     22               222222222   une  meilleur           
                                                        //             22     22               222222222     gestion des  
    for ( i = 1 ; i <=  8 ; i++ ){             //  partie montante    2222   2222             22222222222      collisions
      for ( j = 0 ;  j > - (int)(50 /8 ) * i ; j--) {   //            2222   2222             22222222222           
         matrice [x_ini + i] [y_ini + j] = ID_pic;      //           222222 222222           2222222222222        
      }                                                 //          222222222222222         222222222222222                
    } 
    
    for (i = 9 ; i < longueur * 50 - 8 ; i++ ) {
      for (j = 0 ; j > -50 ; j--) {
        matrice [x_ini + i] [y_ini + j] = ID_pic;
      }
    }
    
    
    for ( i = 0 ; i <=  7 ; i++ ){
      for ( j = 0 ;  j > (int)(- 50 + i * (50/8)) ; j--) {
         matrice [x_ini + i + longueur] [y_ini + j] = ID_pic ;
      }
    }
}

void matrice_pic_plaf (int x_ini, int y_ini, int longueur) {    // /!\ Les coordonnées des pics sont ceux en haut à gauche !!!!!!!!!!!!!!!!!!!!!!!!!!!
  int i ;                                                          
  int j ;                                             
                                                          
                                                       
    for ( i = 1 ; i <=  8 ; i++ ){                      
      for ( j = 0 ;  j > - (int)(50 /8 ) * i ; j--) {            
         matrice [x_ini + i] [y_ini - j] = ID_pic;                                    
      }
    } 
    
    for (i = 9 ; i < longueur * 50 - 8 ; i++ ) {
      for (j = 0 ; j > -50 ; j--) {
        matrice [x_ini + i] [y_ini - j] = ID_pic;
      }
    }
    
    
    for ( i = 0 ; i <=  7 ; i++ ){
      for ( j = 0 ;  j > (int)(- 50 + i * (50/8)) ; j--) {
         matrice [x_ini + i + longueur] [y_ini - j] = ID_pic ;
      }
    }
      
}


void reset_matrice () {          
  int j ;                
  int i ;
  
  for (i = 0 ; i < 12000 ; i++ ){
    for (j = 0 ; j <900 ; j++ ){
     matrice [i] [j] = 0 ; 
     set (i , j, #FFFFFF) ;
    }
  }
}









void mort(){
 if( collision_b == ID_pic || collision_h == ID_pic || collision_d == ID_pic || collision_g == ID_pic || y > 850){
  fill(0);
  rect(0,0,1600,900);
  delay(100);
  
  xi = 0;
  x = 100;
  y = 550; 
  nombre_morts ++;
  score = 0;
  f1_1.pick = 0;
  f1_2.pick = 0;
  f1_3.pick = 0;
  f1_4.pick = 0;
  f1_5.pick = 0;
  f1_6.pick = 0;
  f1_7.pick = 0;
  f1_8.pick = 0;
  f1_9.pick = 0;
 } 
 
 image(bobby_mort,10,10);
 
 String nombre_m = ": "+nombre_morts+" " ;
 textFont(nb_morts,25);
 fill(0);
 text(nombre_m,40,30);
 text(nombre_m,42,28);
 text(nombre_m,44,30);
 text(nombre_m,42,32);
 fill(255,0,0);
 text(nombre_m,42,30);
}








void chrono(){
  fps = fps + 1;              //Cette variable permet de compter le nombre d'images par seconde affichées depuis l'appel de la fonction chrono
  
  if(fps%60 == 0){            //Toutes les 60 images
   sec = sec + 1;             //la variables seconde augmente
  }
  if(sec == 60){              //Si la variable seconde est égale à 60
   sec = 0;                   //alors on la reinitialise
   min = min + 1;             //et la variable minute augmente
  }  
  
 String chronometre = ""+min+" : "+sec;        //déclaration du texte à afficher
 textFont(chrono,30);                          //taille de la police
 fill(0);                                      //couleur du texte (0 = noir)
 text(chronometre,1498,40);     //L'affichage de ces quatres textes noirs
 text(chronometre,1500,38);     //permet de donner l'illusion d'un contour noir
 text(chronometre,1500,42);     //afin de faciliter la lecture du chronometre
 text(chronometre,1502,40);     //les coordonnées sont à chaque fois décalées de 2
 fill(255);                                    //couleur du texte (255 = blanc)
 text(chronometre,1500,40);                    //affichage du texte en indiquant les coordonnées
}








void declenchement_pause(){
 if(keyPressed==true){              //Si on appuie sur une touche
  if(key == 'p'){                   //Si cette touche est la touche P
   chronologie = 4;                 //Alors on affiche le menu pause
  }
 } 
}











void decors(){ 
  image(nuage1,xn1,yn1);                   //affichage des nuages
  image(nuage2,xn2,yn2);
  
                                           //reglage de la vitesse des nuages en fonction de la vitesse de bobby
  if(droite == 1 && collision_d == 0){                         //Si on appuie sur la fleche de droite
    vent = 0.5;                            //alors la vitesse des nuages est de 0.5
    if(x >=700 && x<750){                           //mais si le decors recule(=bobby avance)
     vent = 3;                             //alors il faut augmenter le vent pour paraitre plus réaliste
    }
  }
  
  if(gauche == 1 && collision_g == 0){                         //Si on appuie sur la fleche de gauche
    vent = 0.5;                            //alors la vitesse des nuages est de 0.5
    if(x >= 700 && x<750){                          
    vent = 1;
    }
  }
  
  if((gauche !=1 && droite !=1) || (gauche == 1 && droite ==1) || (gauche == 1 && collision_g != 0) || (droite == 1 && collision_d != 0)){            //Si bobby ne bouge pas
   vent = 0.5;                             //alors le vent est egal à 0.5
  }
  
  
  xn1 = xn1 - vent;                       //mouvement horizontale des nuages
  xn2 = xn2 - vent;
  
                                          
  if(xn1+350 <= 0){                       //Si le nuage 1 arrive a gauche de la fenetre
   xn1 = 1600;   //alors ses coordonnées sont modifiées pour qu'il réapparaisse à droite
   yn1 = 50;
  }
  if(xn2+350 <= 0){                       //Si le nuage 2 arrive à gauche de la fenetre
   xn2 = 1600;                            //alors ses coordonnées sont modifiées pour qu'il réapparaisse à droite
   yn2 = 70;
   }
                                          //Rajout d'un mouvement verticale (pour faire plus joli)    
  if(xn1>900){                            //Si le nuage 1 est dans la partie droite de l'ecran (>900)
   yn1 = yn1 - 0.05;                      //alors il monte doucement
  } else{                                 //Sinon
   yn1 = yn1 + 0.05;                      //il descend doucement
  }
  
  if(xn2>700){                            //Si le nuage 2 est dans la partie droite de l'ecran (>700)
   yn2 = yn2 - 0.05;                      //alors il monte doucement
  } else{                                 //Sinon
   yn2 = yn2 + 0.05;                      //il descend doucement
  }
}










void code_triche () {
 if (etape == 0 && haut == 1) {
  etape = 1 ;
  temps = 0 ;
 }else if (etape == 1 && bas == 1 && haut == 0) {
  etape = 2 ;
  temps = 0 ; 
 }else if (etape == 2 && haut == 1 && bas == 0) {
  etape = 3 ;
  temps = 0 ;
 }else if (etape == 3 && bas == 1 && haut == 0) {
  etape = 4 ;
  temps = 0 ;
 }else if (etape == 4 && gauche == 1 && bas == 0) {
  etape = 5 ;
  temps = 0 ; 
 }else if (etape == 5 && droite == 1 && gauche == 0) {
  etape = 6 ;
  temps = 0 ; 
 }else if (etape == 6 && gauche == 1 && droite == 0) {
  etape = 7 ;
  temps = 0 ; 
 }else if (etape == 7 && droite == 1 && gauche == 0) {
  etape = 0 ;
  temps = 0 ; 
  couleur_bobby = 8 ;
  
 }else if (temps > 60) {
  etape = 0 ; 
 }
 temps ++ ;
}

















void gestion_niveau() {
  noCursor(); 
  gestionbobby();
  chrono();
  declenchement_pause();
  mort();
  code_triche ();
  //gestion_fleurs();
 // gestion_victoire();
}











void init_niv1(){               //Reinitialisation des variables utiles au fonctionnement du premier niveau

  niveau = loadImage("niveau intro.jpg");
  
  longueur_niveau = 5350;
  hauteur_niveau = 900;
  
  
  reset_matrice();
  
  
  nb_fleurs_max = 9;
  niv = 8;  //niv = 8 : niveau 1
 
  x = 100;                 //coordonnées de départ de Bobby
  y = 650;                 //
  xi = 0;                     //On fixe l'image du niveau à gauche
  fps = 0;                       //On remet à zero le chronometre     
  sec = 0;                       //
  min = 0;                       //
  score = 0 ;                       //On met à zero le nombre de fleurs récoltés
  nombre_morts = 0;                 //Ainsi que le nombre d'essais
  

  
  //SOL
  plateforme_matrice(0,700,28,4) ;
  plateforme_matrice(1400,750,6,3) ;
  plateforme_matrice(1700,700,20,4) ;
  plateforme_matrice(2300,650,8,1);
  plateforme_matrice(2450,600,5,1);
  plateforme_matrice(2600,550,2,1);
  plateforme_matrice(2850,700,34,4);
  plateforme_matrice(3900,650,2,1);
  plateforme_matrice(4100,650,1,1);
  
  plateforme_matrice(5150,0,4,18);
  
  //PLATEFORMES
  plateforme_matrice(900,550,3,1);
  plateforme_matrice(1400,550,6,1);
  plateforme_matrice(2850,400,3,1);
  plateforme_matrice(3150,550,3,1);
  
  //PICS
  matrice_pic(1400, 800, 6) ;  
  matrice_pic(3800, 700, 2) ;  
  matrice_pic(4000, 700, 2) ;
  matrice_pic(4150, 700, 2) ;
  
  f1_1.pick = 0;
  f1_2.pick = 0;
  f1_3.pick = 0;
  f1_4.pick = 0;
  f1_5.pick = 0;
  f1_6.pick = 0;
  f1_7.pick = 0;
  f1_8.pick = 0;
  f1_9.pick = 0;
  
  chronologie = 8;
}





void niveau_1(){
   decors();
  
   f1_1.maj() ;
   f1_2.maj() ;
   f1_3.maj();
   f1_4.maj();
   f1_5.maj();
   f1_6.maj();
   f1_7.maj();
   f1_8.maj();
   f1_9.maj();
   
   if(x-xi>4550 && y>750){
    chronologie = 5;
   }
}






void init_niv2(){
  
  niveau = loadImage("niveau 2.jpg");
  
  longueur_niveau = 6000;
  hauteur_niveau = 900;
  
 
  reset_matrice();
  
  
  niv = 10;  //niv = 10 : niveau 2;
  nb_fleurs_max = 0;
  
  x = 120;
  y = 0;
  xi = 0;
  fps = 0;
  sec = 0;
  min = 0;
  score = 0;
  nombre_morts = 0;
  
  
  
  //SOL ET PLATEFORMES
  plateforme_matrice(0,750,120,3);
  plateforme_matrice(300,700,2,1);
  plateforme_matrice(350,650,1,1);
  plateforme_matrice(450,650,3,1);     //plateforme
  plateforme_matrice(650,650,1,1);
  plateforme_matrice(650,700,11,1);
  plateforme_matrice(800,650,8,1);
  plateforme_matrice(850,500,7,3);
  plateforme_matrice(850,450,1,1);
  plateforme_matrice(1000,450,4,1);
  plateforme_matrice(1100,350,2,2);
  plateforme_matrice(850,250,7,2);
  plateforme_matrice(650,500,2,1);
  plateforme_matrice(500,400,2,1);
  plateforme_matrice(650,300,2,1);
  plateforme_matrice(1200,300,2,1);
  plateforme_matrice(1400,250,2,1);
  plateforme_matrice(1400,400,2,1);
  plateforme_matrice(1300,550,2,1);
  plateforme_matrice(1500,650,6,2);
  plateforme_matrice(1800,500,1,1);
  plateforme_matrice(1800,300,1,1);
  plateforme_matrice(2000,650,4,2);
  plateforme_matrice(2000,600,1,1);
  plateforme_matrice(2150,600,1,1);
  plateforme_matrice(2000,400,4,1);
  plateforme_matrice(2000,450,1,1);
  plateforme_matrice(2150,450,1,1);
  plateforme_matrice(2000,200,4,1);
  plateforme_matrice(2300,550,2,1);
  plateforme_matrice(2500,650,2,2);
  plateforme_matrice(2700,550,2,1);
  plateforme_matrice(2600,400,2,1);
  plateforme_matrice(2700,250,2,1);
  plateforme_matrice(2900,200,4,11);
  plateforme_matrice(3100,250,2,10);
  plateforme_matrice(3200,200,2,11);
  plateforme_matrice(3300,300,4,9);
  plateforme_matrice(3500,400,8,7);
  plateforme_matrice(3900,450,2,6);
  plateforme_matrice(4000,400,8,7);
  plateforme_matrice(4400,700,2,1);
  plateforme_matrice(4600,700,7,1);
  plateforme_matrice(5150,700,9,1);
  plateforme_matrice(5750,700,5,1);
  plateforme_matrice(3750,200,8,1);
  plateforme_matrice(4400,550,2,1);
  plateforme_matrice(4500,400,2,1);
  plateforme_matrice(4700,350,2,1);
  plateforme_matrice(4850,550,2,1);
  plateforme_matrice(4900,250,2,1);
  plateforme_matrice(5000,450,2,1);
  plateforme_matrice(5150,600,2,1);
  plateforme_matrice(5200,300,2,1);
  plateforme_matrice(5400,400,2,1);
  plateforme_matrice(5450,550,2,1);
  plateforme_matrice(5650,250,2,1);
  plateforme_matrice(5800,450,2,1);
  
  
  //PLAFOND ET MURS
  plateforme_matrice(0,0,1,15);
  plateforme_matrice(50,0,1,1);
  plateforme_matrice(200,0,116,1);
  plateforme_matrice(300,50,3,1);
  plateforme_matrice(300,100,2,1);
  plateforme_matrice(300,150,1,1);
  plateforme_matrice(300,200,3,1);
  plateforme_matrice(1500,50,6,10);
  plateforme_matrice(2900,50,14,1);
  plateforme_matrice(4400,50,32,3);
  plateforme_matrice(5900,200,2,8);
  
  //PICS
  matrice_pic(700,700,2);
  matrice_pic(900,500,2);
  matrice_pic(900,250,2);
  matrice_pic(1200,300,2);
  matrice_pic(1400,250,2);
  matrice_pic(1200,750,6);
  matrice_pic(1800,750,4);
  matrice_pic(2200,750,6);
  matrice_pic(2600,750,6);
  matrice_pic(3100,250,2);
  matrice_pic(3300,300,2);
  matrice_pic(4500,750,2);
  matrice_pic(4950,750,4);
  matrice_pic(5600,750,3);
  
  chronologie = 10;
} 





void niveau_2(){
if(x-xi>5946){
    chronologie = 5; 
   }
}

void stop() {
  mus_jeu.close();
  mus_menu.close();
  minim.stop();
  super.stop();
}
