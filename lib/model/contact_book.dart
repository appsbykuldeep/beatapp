class ContactBook {
  String? VILLAGENAME = "",
      PERSON_NAME = "",
      DESIGNATION_NAME = "",
      DESIGNATION_ID = "",
      MOBILE_NUMBER = "";

  static ContactBook fromJson(json) {
    var contactBook = ContactBook();
    contactBook.VILLAGENAME = json["VILLAGENAME"].toString();
    contactBook.PERSON_NAME = json["PERSON_NAME"].toString();
    contactBook.DESIGNATION_NAME = json["DESIGNATION_NAME"].toString();
    contactBook.DESIGNATION_ID = json["DESIGNATION_ID"].toString();
    contactBook.MOBILE_NUMBER = json["MOBILE_NUMBER"].toString();
    return contactBook;
  }
}
