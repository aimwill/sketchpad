console.log "Alice's Sketchpad"
# Create div, insert into dom, decrease counter; counter = user input value

var counter = document.getElementById('length').value;

var createDivs = function(){
  for(i = length; i > 0; i-=){
    document.createElement('div');
    document.body.appendChild('div');
  }