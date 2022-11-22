
//Cuerpo:Ó§ pared: ® pasto:° comida:* direccion: v ^ < >

/*
Hecho por: Jose Cabrera
Github user: xJopar
 
Diccionario.
	*vibora[5]: Será el cuerpo que tendra la vibora
	*terreno[]: Es el terreno donde se desarollara
	* fl,cl: Fila long y cadena long
	* cf,cc: cabeza fila y cabeza columna
	* pd: Proxima direccion
	*pm: Proximo movimiento
	*primera: Primer punto
	*aux: variable auxiliar
*/
var
vibora: vector[5] cadena
terreno: matriz[22,34] cadena
pm: matriz[5,2] numerico
cf,cc,primera: numerico
go: logico
i,j,k,fl,cl,aux: numerico //Utiles
pts:numerico
cabeza,cuerpo,pastito,limite,comida,direccion,mov,razon,pd: cadena
inicio
	cls()
//Declaracion primaria.
	fl=22
	cl=34
	cabeza="Ó"
	cuerpo="§"
	pastito="°"
	comida="*"
	limite="®"
	go=FALSE
	j=0
	pts=0
	vibora[1]=cabeza
	//Primer movimietno
	mov="a"
	//Construccion del terreno
	constru()
	//Colocacion de la vibora
	cf=fl/2
	cc=cl/2
	pm[1,1]=cf
	pm[1,2]=cc
	pm[2,1]=cf+1
	pm[2,2]=cc+1
	pm[3,1]=cf+2
	pm[3,2]=cc+2
	pm[4,1]=cf+3
	pm[4,2]=cc+3
	pm[5,1]=cf+4
	pm[5,2]=cc+4

	terreno[cf,cc]=vibora[1]
	terreno[cf,cc+1]=vibora[2]
	terreno[cf,cc+2]=vibora[3]
	terreno[cf,cc+3]=vibora[4]
	terreno[cf,cc+4]=vibora[5]

	repetir
	//Generador MIP [M.ovimientoI.mpresionP.utuador]
		MIP()
	hasta(go)

	cls() //Limpia
	desde i=2 hasta fl-1{
		desde k=2 hasta cl-1{
			si(terreno[i,k]<>cuerpo and terreno[i,k]<>cabeza){
				terreno[i,k]=pastito
			}
		}
	}
	//Impresion
	desde i=1 hasta fl{
		desde k=1 hasta cl{	
			imprimir(terreno[i,k])
		}
		imprimir("\n")
	}
	imprimir("El juego ha terminado porque " ,razon)
	imprimir("\nSu puntaje es de: " ,pts ,"/4")
fin


//La construccion del terreno.
sub constru()
inicio
	desde i=1 hasta fl{
		desde k=1 hasta cl{
			terreno[i,k]=pastito
		}
	}
	desde i=1 hasta fl{
		terreno[i,1]=limite
		terreno[i,cl]=limite
	}
	desde i=1 hasta cl{
		terreno[1,i]=limite
		terreno[fl,i]=limite
	}
fin

//Generador de movimiento, impresion y recolector de puntos.
sub MIP()
inicio
	cls()
	
	si(j>0){
		movimiento()
	}
	limpieza()

	//Direccion segun movimiento
	eval{
		caso(mov=="w")
			direccion="^"
			pd="s"
		caso(mov=="a")
			direccion="<"
			pd="d"
		caso(mov=="s")
			direccion="v"
			pd="w"
		caso(mov=="d")
			direccion=">"
			pd="a"
	}

	//Impresion
	desde i=1 hasta fl{
		desde k=1 hasta cl{	
			imprimir(terreno[i,k])
		}
		imprimir("\n")
	}
	imprimir("La direccion Actual es: " ,direccion)
	imprimir("\tSu puntaje es de: " ,pts ,"/4")
	imprimir("\nIngrese su siguiente movimiento[W,A,S,D]... ")
	i=0
	repetir
		si(i>0){
			imprimir("\nColoque una tecla validad.")
		}
		i=i+1
		leer(mov)
		mov=lower(mov)
	hasta(mov=="w" or mov=="s" or mov=="d" or mov=="a")
	//Comprobacion para no introducir la direccion contraria
	si(mov==pd){
		repetir
			imprimir("\nNo puedes colocar una direccion contraria, coloque una validad... ")
			leer(mov)
		hasta(mov<>pd)
	}	
	//Comprobacion de pared o cuerpo "razon"
	compro()
	//Comprobacion de puntos y generacion de puntos
	puntos()
	j=j+1
fin

sub movimiento()
inicio
	//Evaluacion numerica
	eval{
		caso(mov=="w")
			cf=cf-1
			cc=cc
		caso(mov=="s")
			cf=cf+1
			cc=cc
		caso(mov=="a")
			cc=cc-1
			cf=cf
		caso(mov=="d")
			cc=cc+1
			cf=cf
	}
	//Otorga proximo movimiento a cada parte del cuerpo
	desde i=5 hasta 2 paso -1{
		pm[i,1]=pm[i-1,1]
		pm[i,2]=pm[i-1,2]
	}
	pm[1,1]=cf
	pm[1,2]=cc
	//Generacion del movimiento por medio de sustucion en el terreno
	desde i=1 hasta 5{
		terreno[pm[i,1],pm[i,2]]= vibora[i]
	}
fin

sub limpieza()
inicio
	desde i=2 hasta fl-1{
		desde k=2 hasta cl-1{
			si(terreno[i,k]<>cuerpo and terreno[i,k]<>cabeza and terreno[i,k]<>comida ){
				terreno[i,k]=pastito
			}
		}
	}
fin

sub compro()
var
auxf,auxc: numerico
inicio
	auxf=pm[1,1]
	auxc=pm[1,2]

	//Paredes
	eval{
		caso(mov=="w" and auxf==2)
			go=TRUE
			razon="Chocaste por una pared"
		caso(mov=="a" and auxc==2)
			go=TRUE
			razon="Chocaste por una pared"
		caso(mov=="s" and auxf==(fl-1))
			go=TRUE
			razon="Chocaste por una pared"
		caso(mov=="d" and auxc==(cl-1))
			go=TRUE
			razon="Chocaste por una pared"
	}
	//Cuerpo
	eval{
		caso(mov=="w" and terreno[auxf-1,auxc]==cuerpo)
			go=TRUE
			razon="Chocaste por tu cuerpo"
		caso(mov=="a" and terreno[auxf,auxc-1]==cuerpo)
			go=TRUE
			razon="Chocaste por tu cuerpo"
		caso(mov=="s" and terreno[auxf+1,auxc]==cuerpo)
			go=TRUE
			razon="Chocaste por tu cuerpo"
		caso(mov=="d" and terreno[auxf,auxc+1]==cuerpo)
			go=TRUE
			razon="Chocaste por tu cuerpo"
	}
	si(pts==4){
		go=TRUE
		razon="Conseguiste todos los puntos"
	}
fin

sub puntos()
var
f ,c,auxf,auxc:numerico
inicio
	auxf=pm[1,1]
	auxc=pm[1,2]
	//Generar la primera comida
	si(primera==0){
		repetir
			f= random(fl-1)+2
		hasta(f<>fl and f<>1)
		repetir
			c=random(cl-1)+2
		hasta(c<>cl and c<>1)
		terreno[f,c]=comida
		primera=1
	}
	//Conseguir el punto
	eval{
		caso(mov=="w" and terreno[auxf-1,auxc]==comida)
			pts=pts+1
			primera=0
		caso(mov=="a" and terreno[auxf,auxc-1]==comida)
			pts=pts+1
			primera=0
		caso(mov=="s" and terreno[auxf+1,auxc]==comida)
			pts=pts+1
			primera=0
		caso(mov=="d" and terreno[auxf,auxc+1]==comida)
			pts=pts+1
			primera=0
	}	
	//Agregar cola
	eval{
		caso(pts==1)
			vibora[2]=cuerpo
		caso(pts==2)
			vibora[3]=cuerpo
		caso(pts==3)
			vibora[4]=cuerpo
		caso(pts==4)
			vibora[5]=cuerpo
	}
fin
