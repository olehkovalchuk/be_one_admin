AdminApp.factory "Config", ->
  perPage: 25
  dateFormat: "DD.MM.YYYY HH:mm"
  availableLangs: ["ru","en","uk"]
  emailFormat: /^[a-z]+[a-z0-9._]+@[a-z]+\.[a-z.]{2,5}$/
  intFloatFormat: /^[0-9]+(\.[0-9]{1,2})?$/
