(function () {
  'use strict';

  function options(select) {
    return Array.prototype.slice.call(select.options);
  }

  function visible(option, yes) {
    option.hidden = !yes;
    option.disabled = !yes;
  }

  function updateProgrammePlaceholder(institute, programme) {
    var placeholder = options(programme).find(function (option) { return !option.value; });
    if (!placeholder) return;
    var available = options(programme).some(function (option) {
      return option.value && !option.hidden && !option.disabled;
    });
    placeholder.textContent = institute.value && !available ? 'None available for selected institute' : 'Select';
  }

  function programmes(institute, programme) {
    options(programme).forEach(function (option) {
      visible(option, !option.value || (!!institute.value && option.dataset.instituteId === institute.value));
    });

    if (programme.selectedOptions.length && programme.selectedOptions[0].disabled) {
      programme.value = '';
    }
    updateProgrammePlaceholder(institute, programme);
  }

  function institutes(school, institute, programme) {
    var linked = options(institute).some(function (option) {
      return option.value && option.dataset.schoolId && option.dataset.schoolId === school.value;
    });

    options(institute).forEach(function (option) {
      visible(option, !option.value || !school.value || !linked || option.dataset.schoolId === school.value);
    });

    if (institute.selectedOptions.length && institute.selectedOptions[0].disabled) {
      institute.value = '';
    }

    programmes(institute, programme);
  }

  document.addEventListener('DOMContentLoaded', function () {
    Array.prototype.forEach.call(document.querySelectorAll('form[data-academic-form]'), function (form) {
      var school = form.querySelector('select[name="school_id"]');
      var institute = form.querySelector('select[name="institute_id"]');
      var programme = form.querySelector('select[name="programme_id"]');

      if (!school || !institute || !programme) return;

      school.addEventListener('change', function () {
        institutes(school, institute, programme);
      });

      institute.addEventListener('change', function () {
        programmes(institute, programme);
      });

      institutes(school, institute, programme);
    });
  });
}());
