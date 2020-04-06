#include <SPI.h>
#include <Ethernet.h>
/*Programme01 - Manu - 10.03.2019*/

/*
 # This sample code is used to test the pH meter V1.0.
 # Editor : YouYou
 # Ver    : 1.0
 # Product: analog pH meter
 # SKU    : SEN0161
*/
#define SensorPin A0            //pH meter Analog output to Arduino Analog Input 0
#define Offset 0.7            //deviation compensate observation 23-03-19
#define LED 13
#define samplingInterval 20
#define printInterval 14400000L //toutes les 4h
#define ArrayLenth  40    //times of collection
#define Redoxset 0            //deviation compensate redox value
int pHArray[ArrayLenth];   //Store the average value of the sensor feedback
int pHArrayIndex=0;    
byte mac[] = { 0x90, 0xA2, 0xda, 0x00, 0x2f, 0xe4 };    // Adresse MAC Arduino
// la clé API de Jeedom pour le 'virtuel'
String APIKEYJEEDOM = "45y6w1GigmZvL2Y6UPlHCZt6ckspMmWI";
// IP de la box Jeedom
IPAddress IPjeedom(192,168,1,51);
// Variables pour comparer l'ancienne valeur des sondes à la nouvelle
int t_old = 0;
int h_old = 0;
// On créé l'objet client pour la connexion au serveur
EthernetClient client;
// POUR DEBUG
// Variable pour compter le nombre de connexion échouée de client.connect
int NombreErreurReseau = 0 ;
int NombreProblemeDeconnexion = 0 ;

//pour le redox
int pin_orp = A9;          // Pin ORP Probe
float redox_sensor_value = 0.0;             // value read in Volt (0 to 5)
float redox_value_float = 0.0;        // redox value from -2000 to 2000 mV in float
int redox_value_int = 0;
void setup(void)
{
  pinMode(LED,OUTPUT);
  Ethernet.begin(mac);  
  Serial.begin(9600);  
  //Serial.println("pH meter experiment!");    //Test the serial monitor
}
void loop(void)
{
  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue,voltage;
  if(millis()-samplingTime > samplingInterval)
  {
      pHArray[pHArrayIndex++]=analogRead(SensorPin);
      if(pHArrayIndex==ArrayLenth)pHArrayIndex=0;
      voltage = avergearray(pHArray, ArrayLenth)*5.0/1024;
      pHValue = 3.5*voltage+Offset;
      samplingTime=millis();
  }
  if(millis() - printTime >= printInterval)   //Every printInterval milliseconds, print a numerical, convert the state of the LED indicator
  {
  //Serial.print("Voltage:");
        //Serial.print(voltage,2);
        //Serial.print("    pH value: ");
  //Serial.println(pHValue,1);
        digitalWrite(LED,digitalRead(LED)^1);
        printTime=millis();
        EnvoiTrame(803,pHValue);
        orp_value();  //recupere la valeur Redox
         // Transforme float to int
        redox_value_int = (int) redox_value_float;
        EnvoiTrame(804,redox_value_int);
  }

}
double avergearray(int* arr, int number){
  int i;
  int max,min;
  double avg;
  long amount=0;
  if(number<=0){
    Serial.println("Error number for the array to avraging!/n");
    return 0;
  }
  if(number<5){   //less than 5, calculated directly statistics
    for(i=0;i<number;i++){
      amount+=arr[i];
    }
    avg = amount/number;
    return avg;
  }else{
    if(arr[0]<arr[1]){
      min = arr[0];max=arr[1];
    }
    else{
      min=arr[1];max=arr[0];
    }
    for(i=2;i<number;i++){
      if(arr[i]<min){
        amount+=min;        //arr<min
        min=arr[i];
      }else {
        if(arr[i]>max){
          amount+=max;    //arr>max
          max=arr[i];
        }else{
          amount+=arr[i]; //min<=arr<=max
        }
      }//if
    }//for
    avg = (double)amount/(number-2);
  }//if
  return avg;
}


void orp_value () {
//####################################################################################################
//                            Fonction qui retourne la valeur Redox / ORP                            #
//####################################################################################################

    
                //en utilisant la formation orp : http://www.robotshop.com/media/files/pdf/product-manual-1130.pdf
        // ORP (V) = (2.5 - SensorValue / 200) / 1.037
                //redox_sensor_value = analogRead(pin_orp) * 5000.0 / 1023.0 / 1000.0;   // form 0.0 to 5.0 V
                // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
        //ORP (V) = (2.5 - SensorValue / 200) / 1.037
    redox_sensor_value = analogRead(pin_orp) * (5.0 / 1023.0);   // form 0.0 to 5.0 V
//    Serial.print("pin_orp="); Serial.print(pin_orp);
//    Serial.print(" redox_sensor_value="); Serial.println(redox_sensor_value);
    redox_value_float = ((2.5 - redox_sensor_value) / 1.037) * 1000.0 + Redoxset;      // from -2000 to 2000 mV
    Serial.print("Orp="); Serial.println(redox_value_float, 0);
    if (redox_value_float<0){
                      redox_value_float = redox_value_float * -1;
//                      Serial.print("Orp="); Serial.println(redox_value_float, 1);
                      } 
  }


// Fonction permettant d'envoyer en HTTP, une commande type GET au serveur
// Premier paramétre correspond à l'ID du virtuel dans Jeedom (un ID par valeur à récupérer)
// Deuxième paramètre correspond à la valeur à envoyer pour cet ID
void EnvoiTrame(int ID,float ValeurAEnvoyer)
{
  // On connecte le client au serveur
  int StatutConnexion = client.connect(IPjeedom, 80);

  // Si le client est bien connecté au serveur
  if (StatutConnexion) {
    // POUR DEBUG
    //Serial.print("Connexion OK || ");
  
    client.print(F("GET /core/api/jeeApi.php?apikey="));
    client.print(APIKEYJEEDOM);
    client.print(F("&type=virtual&id="));
    client.print(ID);
    client.print(F("&value="));
    client.print(ValeurAEnvoyer);
    client.println(F(" HTTP/1.1"));
   
    client.println(F("Host: 192.168.1.51"));
    client.println(F("Connection: close"));
    client.println();
  }
  // Sinon (le client n'est pas connecté au serveur)
  else 
  {
    NombreErreurReseau++;
    //POUR DEBUG
    /*Serial.print(F("** Connection failed-code erreur :  "));
    Serial.print(StatutConnexion);
    Serial.print(F(" - ID/Valeur = "));
    Serial.print(ID);
    Serial.print(F("/"));
    Serial.println(ValeurAEnvoyer);*/
  }

  client.flush();
  
  // Petite tempo pour que l'envoi et la réception de la réponse se fasse
  delay (250);

  // Pour DEBUG
  /*
  int CompteurCodeHTTP = 0; // Pour compter les 15 premiers caractères de la réponse du serveur

  // S'il y a une réponse du serveur
  // client.available() = Retourne le nb de bit disponible pour les lire
  while (client.available()) 
  {
    char c = client.read();
    // Affiche la première ligne de ce que retourne le serveur (code HTTP)
    if (CompteurCodeHTTP != 15)
    {
      Serial.print(c);
      CompteurCodeHTTP++;
    }
  }
  Serial.println();
  */
   
  // Si le client est déconnecté
  if (!client.connected()) {
    // POUR DEBUG
    //Serial.println("Deconnexion OK");
    //Serial.println();
  }
  else
  {
      // POUR DEBUG
      // Serial.println(F("Deconnexion : le client etait encore connecte")); // C'est normal si on ne lit pas la réponse du client
      NombreProblemeDeconnexion++;
  }
  // On arrête le client avant de sortir (même s'il est encore connecté)
  client.stop();
}
