class Validations {
 static get mobileValidator => (v) {
        if (v == null || v.isEmpty || v.length!=10) {
          return "Enter valid mobile number";
        } else {
          return null;
        }
      };
 static get emptyValidator => (v) {
        if (v == null || v.isEmpty) {
          return "Can't empty";
        } else {
          return null;
        }
      };

  static bool validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10) {
      return true;
    } else {
      return false;
    }
  }

/*bool validateEmail(String value) {
    String pattern =
        "r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }*/
}
