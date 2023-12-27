window.osuny.translation = {
    init: function () {
        'use strict';
        this.component = document.querySelector('#translation-button');
        this.start = document.querySelector('.js-translation-start');
        this.loader = document.querySelector('.js-translation-loader');
        this.done = document.querySelector('.js-translation-done');
        this.start.addEventListener('click', this.run.bind(this));
        this.url = this.component.dataset.translationUrl;
        this.translatableFields = document.querySelectorAll('[data-translatable]');
    },
    
    run: function () {
        this.start.hidden = true;
        this.loader.hidden = false;
        setTimeout(this.translateAllFields.bind(this), 100);
    },

    translateAllFields: function () {
        for (var i = 0; i < this.translatableFields.length; i++) {
            var field = this.translatableFields[i];
            this.translate(field);
        }
        this.loader.hidden = true;
        this.done.hidden = false;
    },

    translate: function (field) {
        console.log(field);
        var text = field.value, 
            xhr = new XMLHttpRequest();
        console.log(text);
        xhr.open("POST", this.url, false);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.onreadystatechange = function () {
            if (this.readyState != 4) return;
            if (this.status == 200) {
                var data = JSON.parse(this.responseText);
                field.value = data.translatedText;
            }
        };
        xhr.send(JSON.stringify({
            text: text
        }));
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    if (document.querySelector('#translation-button')) {
        window.osuny.translation.init();
    }
});
