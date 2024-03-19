
//nosacījumus precīzi neatcerējos
//pēc koda uzrakstīšanas atcerējos, ka tuvāk tālāk jāpievieno tikai tajā pašā kategorijā,
//līdz ar to pārbaudes funkcija neatbilst nosacījumiem.
//Šobrīt tiek salīdzināts ar piepriekšējo vērtību vienmēr

let jauzmin;
let count=0;//kamēr mazāk par 8 drīkst minēt
let last_distance=0;

function parbaude(vertiba,minejums){
	let distance = Math.abs(vertiba -minejums);
  let teksts="";
  if(distance==0)return"uzminēji!"
  else if(distance<5)teksts = "Ļoti karsts";
  else if(distance<10)teksts = "Karsts";
  else if(distance<20)teksts = "Karstāks";
  else if(distance<35)teksts = "Gandrīz krasts";
  else if(distance<50)teksts = "Silts";
  else if(distance<65)teksts = "Vēs";
  else if(distance<80)teksts = "Auksts";
  else if(distance<90)teksts = "Ļoti auksts";
  else teksts = "Ledains";
  if(count>0){
    if(distance<last_distance){
      teksts+=", nu jau tuvāk";
    }
    else{
      teksts+=", nu jau tālāk";
    }
  }
  last_distance=distance;
  return teksts;
}

function getVal(){
	count=0;
  jauzmin = document.getElementById("number").value;
 	document.getElementById("answer").style = "visibility: visible";
  document.getElementById("number").value = null;  
}
function vaiPareizi(){
	let izvade = "Minējums:"+(count+1).toString();
  let minejums;
	if(count<8){
  	minejums = document.getElementById("guess").value;
    let atbilde = parbaude(jauzmin,minejums);
    izvade+=", "+atbilde
  	document.getElementById("feedback").innerHTML= izvade;
    count++;
  }
  else{
  	document.getElementById("feedback").innerHTML= "Spēle beidzās, ievadi jaunu skaitli un mini vēlreiz";
  }
}