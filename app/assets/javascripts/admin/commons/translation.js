/* global $ */
window.osuny.translation = {
    init: function () {
        'use strict';
        this.component = document.querySelector('#translation-button');
        this.start = document.querySelector('.js-translation-start');
        this.loader = document.querySelector('.js-translation-loader');
        this.done = document.querySelector('.js-translation-done');
        this.csrfToken = document.querySelector('[name="csrf-token"]').content;
        this.url = this.component.dataset.translationUrl;
        this.start.addEventListener('click', this.run.bind(this));
    },

    run: function () {
        'use strict';
        this.start.hidden = true;
        this.loader.hidden = false;
        setTimeout(this.translateAllFields.bind(this), 100);
    },

    translateAllFields: function () {
        'use strict';
        var i,
            field;
        this.translatableFields = document.querySelectorAll('[data-translatable]');
        for (i = 0; i < this.translatableFields.length; i += 1) {
            field = this.translatableFields[i];
            this.translate(field);
        }
        this.loader.hidden = true;
        this.done.hidden = false;
    },

    translate: function (field) {
        'use strict';
        var text = field.value,
            xhr = new XMLHttpRequest(),
            that = this,
            data,
            translatedText;
        xhr.open('POST', this.url, false);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
        xhr.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200 && this.responseText !== '') {
                data = JSON.parse(this.responseText);
                translatedText = data.translatedText;
                that.translateField(field, translatedText);
            }
        };
        xhr.send(JSON.stringify({ text: text }));
    },

    translateField: function (field, text) {
        'use strict';
        var isSummernote = field.dataset.provider === 'summernote' || field.classList.contains('summernote-vue');
        if (isSummernote) {
            $(field).summernote('code', text);
        } else {
            field.value = text;
            // https://stackoverflow.com/questions/56348513/how-to-change-v-model-value-from-js
            field.dispatchEvent(new Event('input'));
        }
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
