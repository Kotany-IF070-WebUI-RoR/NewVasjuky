var quantity = -1;
function init_images_gallery(){
  function buildImage(input, id) {
     if (input.files && input.files[0]) {
          var reader = new FileReader();
          reader.onload = function (e) {
              $("#"+id).attr('src', e.target.result);
          }
          reader.readAsDataURL(input.files[0]);
      }
  }
  quantity++;
  document.getElementsByClassName("nested-fields")[quantity].innerHTML+="<img id='upload-"+quantity+"' src=''/>";



  $(".nested-fields > div > input").change(function(e){
    e.target.parentNode.parentNode.getElementsByTagName("span")[0].className="hide";

    console.log(e.target.parentNode.getElementsByTagName('img'));
    buildImage(this, e.target.parentNode.parentNode.getElementsByTagName('img')[0].id);
  });


}

