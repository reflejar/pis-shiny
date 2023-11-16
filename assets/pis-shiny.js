// Obtén la URL actual
const currentUrl = window.location.href;

// Nuevo fragmento de URL sin el texto que deseas suprimir
const newTextToRemove = "testeos/";
const newUrl = currentUrl.replace(newTextToRemove, "");

// Reemplaza la URL actual en el historial sin recargar la página
history.replaceState({}, document.title, newUrl);