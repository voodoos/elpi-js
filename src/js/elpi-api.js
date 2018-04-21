/* Message from the Elpi worker are 
   treated by the following function */
function onMessage(event) {
    switch (event.data.type) {
        case "answer":
            console.log(event.data);
            break;
        case "log":
            console.log(event.data);
            break;
    }
}

var elpi = new Worker("elpi-worker.js");
/* Binding the onMessage function to the worker */
elpi.onmessage = onMessage;  

class Rectangle {
    constructor(hauteur, largeur) {
      this.hauteur = hauteur;
      this.largeur = largeur;
    }
   
    get area() {
      return this.calcArea();
    }
  
    calcArea() {
      return this.largeur * this.hauteur;
    }
  }
  
  const carré = new Rectangle(10, 10);
  
  console.log(carré.area);