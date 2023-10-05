
function shDescription(){
    let desc = document.querySelector(".extra-information");
    desc.classList.toggle("hidden");
    desc.classList.toggle("shown");
}

function sendMessage(){
    let email = document.getElementById("email").value;
    let msj = document.getElementById("msj").value;

    alert("Correo de " + email + " enviado, con el mensaje: " + msj);
}