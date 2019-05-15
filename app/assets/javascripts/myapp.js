var ICQ = (function() {

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
        },
    }

}());

jQuery(ICQ.init);