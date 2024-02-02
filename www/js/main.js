// Responsive video embeds
var videoEmbeds = [
  'iframe[src*="youtube.com"]',
  'iframe[src*="vimeo.com"]'
];
reframe(videoEmbeds.join(','));

// Mobile menu
var menuToggle = document.querySelectorAll('.menu-toggle');

for (var i = 0; i < menuToggle.length; i++) {
  menuToggle[i].addEventListener('click', function(e){
    document.body.classList.toggle('menu--opened');
    e.preventDefault();
  },false);
}

document.body.classList.remove('menu--opened');

window.addEventListener('resize', function () {
  if (menuToggle.offsetParent === null) {
    document.body.classList.remove('menu--opened');
  }
}, true);

// Accordion
var accordions = document.querySelectorAll('.faq-accordion');
Array.from(accordions).forEach((accordion) => {
  var ba = new BadgerAccordion(accordion, {
    headerClass: '.accordion-trigger',
    panelClass: '.accordion-panel',
    panelInnerClass: '.accordion-content',
    openMultiplePanels: true
  });
});

$('#contact-form').submit(function(e){
    e.preventDefault();
    //do some verification
    $.ajax({
        url: 'https://us-central1-menu-backoffice.cloudfunctions.net/shop/contacts',
        type: "POST",
        data: $(this).serialize(),
        success: (data) => {
            window.location.replace('/contact-response')
        }
    });
});

function validateEmail(email) {
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
}

function subscribe(){
    let email = $('#subscribe-email').val();
    if(validateEmail(email)){
        $.ajax({
            url: 'https://us-central1-menu-backoffice.cloudfunctions.net/shop/subscribers',
            type: "POST",
            data: {email: email},
            success: (data) => {
                $('#subscribe-form-success').show();
                $('#subscribe-form').hide();
            }
        });
    }
}