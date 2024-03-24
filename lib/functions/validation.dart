String? formValidation(String r, String v) {
  switch (r) {
    case 'title':
      if (v.isEmpty) {
        return "Oops! Title is required.";
      } else if (lettersnumbersunderscoreonlycheck(v)) {
        return "Oops! Avoid special characters.";
      } else if (!lengthcheck(v, 2, "min")) {
        return "Oops! 2 characters minimum.";
      } else if (!lengthcheck(v, 100, "max")) {
        return "Oops! 100 characters maximum.";
      }
      break;
    case 'notes':
      if (v.isEmpty) {
        return "Oops! Notes are required.";
      } else if (!lengthcheck(v, 2, "min")) {
        return "Oops! 2 characters minimum.";
      }
      break;
  }
  return null;
}

/*CHECK IF INPUT IS LETTERS, NUMBERS UNDERSCORE ONLY*/

bool lettersnumbersunderscoreonlycheck(String s) {
  if (s.contains(RegExp(r"[^a-zA-Z0-9_\s]"))) {
    return true;
  } else {
    return false;
  }
}

/*CHECK IF INPUT IS LETTERS, NUMBERS UNDERSCORE ONLY*/

/*CHECK IF INPUT MINIMUM/MAXIMUM LENGTH*/

bool lengthcheck(String s, int size, String param) {
  if (param == 'min') {
    if (s.length < size) {
      return false;
    } else {
      return true;
    }
  } else if (param == 'max') {
    if (s.length > size) {
      return false;
    } else {
      return true;
    }
  }
  return false;
}

/*CHECK IF INPUT MINIMUM/MAXIMUM  LENGTH*/

/*CHECK IF INPUT IS NUMBERS ONLY*/

bool numbersonlycheck(String s) {
  if (s.contains(RegExp(r"[^0-9]"))) {
    return true;
  } else {
    return false;
  }
}

/*CHECK IF INPUT IS NUMBERS ONLY*/