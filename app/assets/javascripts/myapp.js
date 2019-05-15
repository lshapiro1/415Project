var ICQ = (function() {

    var student_response_handler = function(ev) {
      var detail = ev.detail;
      var data = detail[0];
      jQuery("#railsflash").hide();
      jQuery("#jsflash").css("opacity", 1.0);
      jQuery("#jsflash").text(data.message);
      jQuery("#jsflash").show();
      jQuery("#jsflash").addClass("alert");
      jQuery("#jsflash").addClass("alert-info");
      jQuery("#jsflash").fadeTo(500, 0.5);
    };

    var drawresponse = function(ev) {
      var detail = ev.detail;
      var data = detail[0];
      console.log(data);
    };

    return {
        init: function() {
            jQuery("#question_type").on('change', function() {
                if (jQuery("#question_type").val() == "MultiChoiceQuestion") {
                    jQuery("#question_qcontent").show();
                } else {
                    jQuery("#question_qcontent").hide();
                }
            });

            jQuery("#responseunfold").on('click', function() {
                jQuery("#responses").toggle();
            });
            jQuery("#new_free_response_poll_response").on('ajax:success', student_response_handler);
            jQuery("#new_multi_choice_poll_response").on('ajax:success', student_response_handler);
            jQuery("#new_numeric_response_poll_response").on('ajax:success', student_response_handler);
            /*
            if (document.getElementById("squestion")) {
            setTimeout(fn, millisec);
            }
            */
            jQuery("#responsesync").on('ajax:success', drawresponse);
        },
    }

}());

jQuery(ICQ.init);
