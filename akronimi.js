//uzd nosacījumi(pēc atmiņas)

// akronīmi

// ja eksistē burts tad random nozīme(no dotā), ja burts atkārtojas tad jāizmanto cits
// vārds, tā līdz visi vārdi no burta izmantoti, 
// ja akronīmā burti turpina atkārtoties drīkst izvēlēties jebjuru random vārdu.
// ja burtam nav nozīme, tad jāizvada "?"
// vārdi jāatdala ar komatu/

function tulkoAkronimu(vards){
  const akronimi = new Map([//atslēga, [pieminēto vārdu skaits, [vai lietots,vārds],[vai lietots,vārds].....]
    ["A", [0,[false,"asprātīgs"], [false,"auns"], [false,"apodziņš"],[false,"apsargs"]]],
    ["S", [0,[false,"students"], [false,"superīgs"], [false,"sieriņš"]]],
    ["P", [0,[false,"prātīgs"], [false,"pelmenis"], [false,"pedālis"]]],
    ["O", [0,[false,"opis"], [false,"opelis"], [false,"optimistisks"]]],
    ["Z", [0,[false,"zinošs"], [false,"zibenīgs"], [false,"zilonis"]]],
    ["T", [0,[false,"tandēms"], [false,"trāpīgs"], [false,"tetris"]]]
  ]);
  let rand; //saturēs random vērtības masīvam
  let nozime = ""; //uzglabās vārdu salikumu, kas veidots no akronīmiem
  let count =0;//Pirmā vārda pārbaude,lai neliktu komatu prims vārda, ja count==0//varēja true/false šā vietā
  let value;//Map izvēlētā key saturs
  let garums;//masīva garums
  for(let burts of vards){
    if(count>0)nozime+=",";//pirms pirmā vārda komatu neliekam
    count+=1;
    
    if(akronimi.has(burts)){
      value=akronimi.get(burts); 
      garums = akronimi.get(burts).length-1;//-1 jo nultā vērtība tur count

      if(value[0]<garums){//zars,kurā izvēlas vārdus, kuri vēl nav minēti
        do{
          rand = 1+Math.floor(Math.random()*garums);//1+ nobīde par 1 jo 0 vērtība count
        }
        while(value[rand][0])//ģenerējam rand kamēr atrod neizmantotu vārdu
        nozime += value[rand][1];
        value[rand][0]=true;
        value[0]++;
      }
      else{
        rand = 1+Math.floor(Math.random()*garums);//1+ nobīde par 1 jo 0 vērtība count
        nozime += value[rand][1];
      }      
    }
    else{//gadījumā ja burts akronīmā nav zināms
      nozime +="?";
    }
  }
  
  return nozime;
}

//testa gadījumi

console.log(tulkoAkronimu("ZZZZZZZZ"));
console.log(tulkoAkronimu("AAAAAAAA"));
console.log(tulkoAkronimu("SSSSSSS"));
console.log(tulkoAkronimu("PPPPPPPP"));
console.log(tulkoAkronimu("OOOOOOOO"));
console.log(tulkoAkronimu("RTRTPTKTNTTTTN"));