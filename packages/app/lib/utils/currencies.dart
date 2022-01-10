class Country {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String currencyCode;
  final String currencyName;
  Country(
      {required this.isoCode,
      required this.iso3Code,
      required this.currencyCode,
      required this.currencyName,
      required this.name});

  factory Country.fromMap(Map<String, String> map) => Country(
        name: map['name']!,
        isoCode: map['isoCode']!,
        iso3Code: map['iso3Code']!,
        currencyCode: map['currencyCode']!,
        currencyName: map['currencyName']!,
      );
}

final List<Country> countryList = [
  Country(
    isoCode: "AF",
    currencyCode: "AFN",
    currencyName: "Afghan afghani",
    name: "Afghanistan",
    iso3Code: "AFG",
  ),
  Country(
    isoCode: "AX",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Åland Islands",
    iso3Code: "ALA",
  ),
  Country(
    isoCode: "AL",
    currencyCode: "ALL",
    currencyName: "Albanian lek",
    name: "Albania",
    iso3Code: "ALB",
  ),
  Country(
    isoCode: "DZ",
    currencyCode: "DZD",
    currencyName: "Algerian dinar",
    name: "Algeria",
    iso3Code: "DZA",
  ),
  Country(
    isoCode: "AS",
    currencyCode: "USD",
    currencyName: "United State Dollar",
    name: "American Samoa",
    iso3Code: "ASM",
  ),
  Country(
    isoCode: "AD",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Andorra",
    iso3Code: "AND",
  ),
  Country(
    isoCode: "AO",
    currencyCode: "AOA",
    currencyName: "Angolan kwanza",
    name: "Angola",
    iso3Code: "AGO",
  ),
  Country(
    isoCode: "AI",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Anguilla",
    iso3Code: "AIA",
  ),
  Country(
    isoCode: "AQ",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Antarctica",
    iso3Code: "ATA",
  ),
  Country(
    isoCode: "AG",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Antigua and Barbuda",
    iso3Code: "ATG",
  ),
  Country(
    isoCode: "AR",
    currencyCode: "ARS",
    currencyName: "Argentine peso",
    name: "Argentina",
    iso3Code: "ARG",
  ),
  Country(
    isoCode: "AM",
    currencyCode: "AMD",
    currencyName: "Armenian dram",
    name: "Armenia",
    iso3Code: "ARM",
  ),
  Country(
    isoCode: "AW",
    currencyCode: "AWG",
    currencyName: "Aruban florin",
    name: "Aruba",
    iso3Code: "ABW",
  ),
  Country(
    isoCode: "AU",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Australia",
    iso3Code: "AUS",
  ),
  Country(
    isoCode: "AT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Austria",
    iso3Code: "AUT",
  ),
  Country(
    isoCode: "AZ",
    currencyCode: "AZN",
    currencyName: "Azerbaijani manat",
    name: "Azerbaijan",
    iso3Code: "AZE",
  ),
  Country(
    isoCode: "BS",
    currencyCode: "BSD",
    currencyName: "Bahamian dollar",
    name: "Bahamas",
    iso3Code: "BHS",
  ),
  Country(
    isoCode: "BH",
    currencyCode: "BHD",
    currencyName: "Bahraini dinar",
    name: "Bahrain",
    iso3Code: "BHR",
  ),
  Country(
    isoCode: "BD",
    currencyCode: "BDT",
    currencyName: "Bangladeshi taka",
    name: "Bangladesh",
    iso3Code: "BGD",
  ),
  Country(
    isoCode: "BB",
    currencyCode: "BBD",
    currencyName: "Barbadian dollar",
    name: "Barbados",
    iso3Code: "BRB",
  ),
  Country(
    isoCode: "BY",
    currencyCode: "BYN",
    currencyName: "New Belarusian ruble",
    name: "Belarus",
    iso3Code: "BLR",
  ),
  Country(
    isoCode: "BE",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Belgium",
    iso3Code: "BEL",
  ),
  Country(
    isoCode: "BZ",
    currencyCode: "BZD",
    currencyName: "Belize dollar",
    name: "Belize",
    iso3Code: "BLZ",
  ),
  Country(
    isoCode: "BJ",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Benin",
    iso3Code: "BEN",
  ),
  Country(
    isoCode: "BM",
    currencyCode: "BMD",
    currencyName: "Bermudian dollar",
    name: "Bermuda",
    iso3Code: "BMU",
  ),
  Country(
    isoCode: "BT",
    currencyCode: "BTN",
    currencyName: "Bhutanese ngultrum",
    name: "Bhutan",
    iso3Code: "BTN",
  ),
  Country(
    isoCode: "BO",
    currencyCode: "BOB",
    currencyName: "Bolivian boliviano",
    name: "Bolivia (Plurinational State of)",
    iso3Code: "BOL",
  ),
  Country(
    isoCode: "BQ",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Bonaire, Sint Eustatius and Saba",
    iso3Code: "BES",
  ),
  Country(
    isoCode: "BA",
    currencyCode: "BAM",
    currencyName: "Bosnia and Herzegovina convertible mark",
    name: "Bosnia and Herzegovina",
    iso3Code: "BIH",
  ),
  Country(
    isoCode: "BW",
    currencyCode: "BWP",
    currencyName: "Botswana pula",
    name: "Botswana",
    iso3Code: "BWA",
  ),
  Country(
    isoCode: "BV",
    currencyCode: "NOK",
    currencyName: "Norwegian krone",
    name: "Bouvet Island",
    iso3Code: "BVT",
  ),
  Country(
    isoCode: "BR",
    currencyCode: "BRL",
    currencyName: "Brazilian real",
    name: "Brazil",
    iso3Code: "BRA",
  ),
  Country(
    isoCode: "IO",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "British Indian Ocean Territory",
    iso3Code: "IOT",
  ),
  Country(
    isoCode: "VG",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Virgin Islands (British)",
    iso3Code: "VGB",
  ),
  Country(
    isoCode: "VI",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Virgin Islands (U.S.)",
    iso3Code: "VIR",
  ),
  Country(
    isoCode: "BN",
    currencyCode: "BND",
    currencyName: "Brunei dollar",
    name: "Brunei Darussalam",
    iso3Code: "BRN",
  ),
  Country(
    isoCode: "BG",
    currencyCode: "BGN",
    currencyName: "Bulgarian lev",
    name: "Bulgaria",
    iso3Code: "BGR",
  ),
  Country(
    isoCode: "BF",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Burkina Faso",
    iso3Code: "BFA",
  ),
  Country(
    isoCode: "BI",
    currencyCode: "BIF",
    currencyName: "Burundian franc",
    name: "Burundi",
    iso3Code: "BDI",
  ),
  Country(
    isoCode: "KH",
    currencyCode: "KHR",
    currencyName: "Cambodian riel",
    name: "Cambodia",
    iso3Code: "KHM",
  ),
  Country(
    isoCode: "CM",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Cameroon",
    iso3Code: "CMR",
  ),
  Country(
    isoCode: "CA",
    currencyCode: "CAD",
    currencyName: "Canadian dollar",
    name: "Canada",
    iso3Code: "CAN",
  ),
  Country(
    isoCode: "CV",
    currencyCode: "CVE",
    currencyName: "Cape Verdean escudo",
    name: "Cabo Verde",
    iso3Code: "CPV",
  ),
  Country(
    isoCode: "KY",
    currencyCode: "KYD",
    currencyName: "Cayman Islands dollar",
    name: "Cayman Islands",
    iso3Code: "CYM",
  ),
  Country(
    isoCode: "CF",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Central African Republic",
    iso3Code: "CAF",
  ),
  Country(
    isoCode: "TD",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Chad",
    iso3Code: "TCD",
  ),
  Country(
    isoCode: "CL",
    currencyCode: "CLP",
    currencyName: "Chilean peso",
    name: "Chile",
    iso3Code: "CHL",
  ),
  Country(
    isoCode: "CN",
    currencyCode: "CNY",
    currencyName: "Chinese yuan",
    name: "China",
    iso3Code: "CHN",
  ),
  Country(
    isoCode: "CX",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Christmas Island",
    iso3Code: "CXR",
  ),
  Country(
    isoCode: "CC",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Cocos (Keeling) Islands",
    iso3Code: "CCK",
  ),
  Country(
    isoCode: "CO",
    currencyCode: "COP",
    currencyName: "Colombian peso",
    name: "Colombia",
    iso3Code: "COL",
  ),
  Country(
    isoCode: "KM",
    currencyCode: "KMF",
    currencyName: "Comorian franc",
    name: "Comoros",
    iso3Code: "COM",
  ),
  Country(
    isoCode: "CG",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Congo",
    iso3Code: "COG",
  ),
  Country(
    isoCode: "CD",
    currencyCode: "CDF",
    currencyName: "Congolese franc",
    name: "Congo (Democratic Republic of the)",
    iso3Code: "COD",
  ),
  Country(
    isoCode: "CK",
    currencyCode: "NZD",
    currencyName: "New Zealand dollar",
    name: "Cook Islands",
    iso3Code: "COK",
  ),
  Country(
    isoCode: "CR",
    currencyCode: "CRC",
    currencyName: "Costa Rican colón",
    name: "Costa Rica",
    iso3Code: "CRI",
  ),
  Country(
    isoCode: "HR",
    currencyCode: "HRK",
    currencyName: "Croatian kuna",
    name: "Croatia",
    iso3Code: "HRV",
  ),
  Country(
    isoCode: "CU",
    currencyCode: "CUC",
    currencyName: "Cuban convertible peso",
    name: "Cuba",
    iso3Code: "CUB",
  ),
  Country(
    isoCode: "CW",
    currencyCode: "ANG",
    currencyName: "Netherlands Antillean guilder",
    name: "Curaçao",
    iso3Code: "CUW",
  ),
  Country(
    isoCode: "CY",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Cyprus",
    iso3Code: "CYP",
  ),
  Country(
    isoCode: "CZ",
    currencyCode: "CZK",
    currencyName: "Czech koruna",
    name: "Czech Republic",
    iso3Code: "CZE",
  ),
  Country(
    isoCode: "DK",
    currencyCode: "DKK",
    currencyName: "Danish krone",
    name: "Denmark",
    iso3Code: "DNK",
  ),
  Country(
    isoCode: "DJ",
    currencyCode: "DJF",
    currencyName: "Djiboutian franc",
    name: "Djibouti",
    iso3Code: "DJI",
  ),
  Country(
    isoCode: "DM",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Dominica",
    iso3Code: "DMA",
  ),
  Country(
    isoCode: "DO",
    currencyCode: "DOP",
    currencyName: "Dominican peso",
    name: "Dominican Republic",
    iso3Code: "DOM",
  ),
  Country(
    isoCode: "EC",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Ecuador",
    iso3Code: "ECU",
  ),
  Country(
    isoCode: "EG",
    currencyCode: "EGP",
    currencyName: "Egyptian pound",
    name: "Egypt",
    iso3Code: "EGY",
  ),
  Country(
    isoCode: "SV",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "El Salvador",
    iso3Code: "SLV",
  ),
  Country(
    isoCode: "GQ",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Equatorial Guinea",
    iso3Code: "GNQ",
  ),
  Country(
    isoCode: "ER",
    currencyCode: "ERN",
    currencyName: "Eritrean nakfa",
    name: "Eritrea",
    iso3Code: "ERI",
  ),
  Country(
    isoCode: "EE",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Estonia",
    iso3Code: "EST",
  ),
  Country(
    isoCode: "ET",
    currencyCode: "ETB",
    currencyName: "Ethiopian birr",
    name: "Ethiopia",
    iso3Code: "ETH",
  ),
  Country(
    isoCode: "FK",
    currencyCode: "FKP",
    currencyName: "Falkland Islands pound",
    name: "Falkland Islands (Malvinas)",
    iso3Code: "FLK",
  ),
  Country(
    isoCode: "FO",
    currencyCode: "DKK",
    currencyName: "Danish krone",
    name: "Faroe Islands",
    iso3Code: "FRO",
  ),
  Country(
    isoCode: "FJ",
    currencyCode: "FJD",
    currencyName: "Fijian dollar",
    name: "Fiji",
    iso3Code: "FJI",
  ),
  Country(
    isoCode: "FI",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Finland",
    iso3Code: "FIN",
  ),
  Country(
    isoCode: "FR",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "France",
    iso3Code: "FRA",
  ),
  Country(
    isoCode: "GF",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "French Guiana",
    iso3Code: "GUF",
  ),
  Country(
    isoCode: "PF",
    currencyCode: "XPF",
    currencyName: "CFP franc",
    name: "French Polynesia",
    iso3Code: "PYF",
  ),
  Country(
    isoCode: "TF",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "French Southern Territories",
    iso3Code: "ATF",
  ),
  Country(
    isoCode: "GA",
    currencyCode: "XAF",
    currencyName: "Central African CFA franc",
    name: "Gabon",
    iso3Code: "GAB",
  ),
  Country(
    isoCode: "GM",
    currencyCode: "GMD",
    currencyName: "Gambian dalasi",
    name: "Gambia",
    iso3Code: "GMB",
  ),
  Country(
    isoCode: "GE",
    currencyCode: "GEL",
    currencyName: "Georgian Lari",
    name: "Georgia",
    iso3Code: "GEO",
  ),
  Country(
    isoCode: "DE",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Germany",
    iso3Code: "DEU",
  ),
  Country(
    isoCode: "GH",
    currencyCode: "GHS",
    currencyName: "Ghanaian cedi",
    name: "Ghana",
    iso3Code: "GHA",
  ),
  Country(
    isoCode: "GI",
    currencyCode: "GIP",
    currencyName: "Gibraltar pound",
    name: "Gibraltar",
    iso3Code: "GIB",
  ),
  Country(
    isoCode: "GR",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Greece",
    iso3Code: "GRC",
  ),
  Country(
    isoCode: "GL",
    currencyCode: "DKK",
    currencyName: "Danish krone",
    name: "Greenland",
    iso3Code: "GRL",
  ),
  Country(
    isoCode: "GD",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Grenada",
    iso3Code: "GRD",
  ),
  Country(
    isoCode: "GP",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Guadeloupe",
    iso3Code: "GLP",
  ),
  Country(
    isoCode: "GU",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Guam",
    iso3Code: "GUM",
  ),
  Country(
    isoCode: "GT",
    currencyCode: "GTQ",
    currencyName: "Guatemalan quetzal",
    name: "Guatemala",
    iso3Code: "GTM",
  ),
  Country(
    isoCode: "GG",
    currencyCode: "GBP",
    currencyName: "British pound",
    name: "Guernsey",
    iso3Code: "GGY",
  ),
  Country(
    isoCode: "GN",
    currencyCode: "GNF",
    currencyName: "Guinean franc",
    name: "Guinea",
    iso3Code: "GIN",
  ),
  Country(
    isoCode: "GW",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Guinea-Bissau",
    iso3Code: "GNB",
  ),
  Country(
    isoCode: "GY",
    currencyCode: "GYD",
    currencyName: "Guyanese dollar",
    name: "Guyana",
    iso3Code: "GUY",
  ),
  Country(
    isoCode: "HT",
    currencyCode: "HTG",
    currencyName: "Haitian gourde",
    name: "Haiti",
    iso3Code: "HTI",
  ),
  Country(
    isoCode: "HM",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Heard Island and McDonald Islands",
    iso3Code: "HMD",
  ),
  Country(
    isoCode: "VA",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Holy See",
    iso3Code: "VAT",
  ),
  Country(
    isoCode: "HN",
    currencyCode: "HNL",
    currencyName: "Honduran lempira",
    name: "Honduras",
    iso3Code: "HND",
  ),
  Country(
    isoCode: "HK",
    currencyCode: "HKD",
    currencyName: "Hong Kong dollar",
    name: "Hong Kong",
    iso3Code: "HKG",
  ),
  Country(
    isoCode: "HU",
    currencyCode: "HUF",
    currencyName: "Hungarian forint",
    name: "Hungary",
    iso3Code: "HUN",
  ),
  Country(
    isoCode: "IS",
    currencyCode: "ISK",
    currencyName: "Icelandic króna",
    name: "Iceland",
    iso3Code: "ISL",
  ),
  Country(
    isoCode: "IN",
    currencyCode: "INR",
    currencyName: "Indian rupee",
    name: "India",
    iso3Code: "IND",
  ),
  Country(
    isoCode: "ID",
    currencyCode: "IDR",
    currencyName: "Indonesian rupiah",
    name: "Indonesia",
    iso3Code: "IDN",
  ),
  Country(
    isoCode: "CI",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Côte d'Ivoire",
    iso3Code: "CIV",
  ),
  Country(
    isoCode: "IR",
    currencyCode: "IRR",
    currencyName: "Iranian rial",
    name: "Iran (Islamic Republic of)",
    iso3Code: "IRN",
  ),
  Country(
    isoCode: "IQ",
    currencyCode: "IQD",
    currencyName: "Iraqi dinar",
    name: "Iraq",
    iso3Code: "IRQ",
  ),
  Country(
    isoCode: "IE",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Ireland",
    iso3Code: "IRL",
  ),
  Country(
    isoCode: "IM",
    currencyCode: "GBP",
    currencyName: "British pound",
    name: "Isle of Man",
    iso3Code: "IMN",
  ),
  Country(
    isoCode: "IL",
    currencyCode: "ILS",
    currencyName: "Israeli new shekel",
    name: "Israel",
    iso3Code: "ISR",
  ),
  Country(
    isoCode: "IT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Italy",
    iso3Code: "ITA",
  ),
  Country(
    isoCode: "JM",
    currencyCode: "JMD",
    currencyName: "Jamaican dollar",
    name: "Jamaica",
    iso3Code: "JAM",
  ),
  Country(
    isoCode: "JP",
    currencyCode: "JPY",
    currencyName: "Japanese yen",
    name: "Japan",
    iso3Code: "JPN",
  ),
  Country(
    isoCode: "JE",
    currencyCode: "GBP",
    currencyName: "British pound",
    name: "Jersey",
    iso3Code: "JEY",
  ),
  Country(
    isoCode: "JO",
    currencyCode: "JOD",
    currencyName: "Jordanian dinar",
    name: "Jordan",
    iso3Code: "JOR",
  ),
  Country(
    isoCode: "KZ",
    currencyCode: "KZT",
    currencyName: "Kazakhstani tenge",
    name: "Kazakhstan",
    iso3Code: "KAZ",
  ),
  Country(
    isoCode: "KE",
    currencyCode: "KES",
    currencyName: "Kenyan shilling",
    name: "Kenya",
    iso3Code: "KEN",
  ),
  Country(
    isoCode: "KI",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Kiribati",
    iso3Code: "KIR",
  ),
  Country(
    isoCode: "KW",
    currencyCode: "KWD",
    currencyName: "Kuwaiti dinar",
    name: "Kuwait",
    iso3Code: "KWT",
  ),
  Country(
    isoCode: "KG",
    currencyCode: "KGS",
    currencyName: "Kyrgyzstani som",
    name: "Kyrgyzstan",
    iso3Code: "KGZ",
  ),
  Country(
    isoCode: "LA",
    currencyCode: "LAK",
    currencyName: "Lao kip",
    name: "Lao People's Democratic Republic",
    iso3Code: "LAO",
  ),
  Country(
    isoCode: "LV",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Latvia",
    iso3Code: "LVA",
  ),
  Country(
    isoCode: "LB",
    currencyCode: "LBP",
    currencyName: "Lebanese pound",
    name: "Lebanon",
    iso3Code: "LBN",
  ),
  Country(
    isoCode: "LS",
    currencyCode: "LSL",
    currencyName: "Lesotho loti",
    name: "Lesotho",
    iso3Code: "LSO",
  ),
  Country(
    isoCode: "LR",
    currencyCode: "LRD",
    currencyName: "Liberian dollar",
    name: "Liberia",
    iso3Code: "LBR",
  ),
  Country(
    isoCode: "LY",
    currencyCode: "LYD",
    currencyName: "Libyan dinar",
    name: "Libya",
    iso3Code: "LBY",
  ),
  Country(
    isoCode: "LI",
    currencyCode: "CHF",
    currencyName: "Swiss franc",
    name: "Liechtenstein",
    iso3Code: "LIE",
  ),
  Country(
    isoCode: "LT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Lithuania",
    iso3Code: "LTU",
  ),
  Country(
    isoCode: "LU",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Luxembourg",
    iso3Code: "LUX",
  ),
  Country(
    isoCode: "MO",
    currencyCode: "MOP",
    currencyName: "Macanese pataca",
    name: "Macao",
    iso3Code: "MAC",
  ),
  Country(
    isoCode: "MK",
    currencyCode: "MKD",
    currencyName: "Macedonian denar",
    name: "Macedonia (the former Yugoslav Republic of)",
    iso3Code: "MKD",
  ),
  Country(
    isoCode: "MG",
    currencyCode: "MGA",
    currencyName: "Malagasy ariary",
    name: "Madagascar",
    iso3Code: "MDG",
  ),
  Country(
    isoCode: "MW",
    currencyCode: "MWK",
    currencyName: "Malawian kwacha",
    name: "Malawi",
    iso3Code: "MWI",
  ),
  Country(
    isoCode: "MY",
    currencyCode: "MYR",
    currencyName: "Malaysian ringgit",
    name: "Malaysia",
    iso3Code: "MYS",
  ),
  Country(
    isoCode: "MV",
    currencyCode: "MVR",
    currencyName: "Maldivian rufiyaa",
    name: "Maldives",
    iso3Code: "MDV",
  ),
  Country(
    isoCode: "ML",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Mali",
    iso3Code: "MLI",
  ),
  Country(
    isoCode: "MT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Malta",
    iso3Code: "MLT",
  ),
  Country(
    isoCode: "MH",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Marshall Islands",
    iso3Code: "MHL",
  ),
  Country(
    isoCode: "MQ",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Martinique",
    iso3Code: "MTQ",
  ),
  Country(
    isoCode: "MR",
    currencyCode: "MRO",
    currencyName: "Mauritanian ouguiya",
    name: "Mauritania",
    iso3Code: "MRT",
  ),
  Country(
    isoCode: "MU",
    currencyCode: "MUR",
    currencyName: "Mauritian rupee",
    name: "Mauritius",
    iso3Code: "MUS",
  ),
  Country(
    isoCode: "YT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Mayotte",
    iso3Code: "MYT",
  ),
  Country(
    isoCode: "MX",
    currencyCode: "MXN",
    currencyName: "Mexican peso",
    name: "Mexico",
    iso3Code: "MEX",
  ),
  Country(
    isoCode: "FM",
    currencyCode: "None",
    currencyName: "[D]",
    name: "Micronesia (Federated States of)",
    iso3Code: "FSM",
  ),
  Country(
    isoCode: "MD",
    currencyCode: "MDL",
    currencyName: "Moldovan leu",
    name: "Moldova (Republic of)",
    iso3Code: "MDA",
  ),
  Country(
    isoCode: "MC",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Monaco",
    iso3Code: "MCO",
  ),
  Country(
    isoCode: "MN",
    currencyCode: "MNT",
    currencyName: "Mongolian tögrög",
    name: "Mongolia",
    iso3Code: "MNG",
  ),
  Country(
    isoCode: "ME",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Montenegro",
    iso3Code: "MNE",
  ),
  Country(
    isoCode: "MS",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Montserrat",
    iso3Code: "MSR",
  ),
  Country(
    isoCode: "MA",
    currencyCode: "MAD",
    currencyName: "Moroccan dirham",
    name: "Morocco",
    iso3Code: "MAR",
  ),
  Country(
    isoCode: "MZ",
    currencyCode: "MZN",
    currencyName: "Mozambican metical",
    name: "Mozambique",
    iso3Code: "MOZ",
  ),
  Country(
    isoCode: "MM",
    currencyCode: "MMK",
    currencyName: "Burmese kyat",
    name: "Myanmar",
    iso3Code: "MMR",
  ),
  Country(
    isoCode: "NA",
    currencyCode: "NAD",
    currencyName: "Namibian dollar",
    name: "Namibia",
    iso3Code: "NAM",
  ),
  Country(
    isoCode: "NR",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Nauru",
    iso3Code: "NRU",
  ),
  Country(
    isoCode: "NP",
    currencyCode: "NPR",
    currencyName: "Nepalese rupee",
    name: "Nepal",
    iso3Code: "NPL",
  ),
  Country(
    isoCode: "NL",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Netherlands",
    iso3Code: "NLD",
  ),
  Country(
    isoCode: "NC",
    currencyCode: "XPF",
    currencyName: "CFP franc",
    name: "New Caledonia",
    iso3Code: "NCL",
  ),
  Country(
    isoCode: "NZ",
    currencyCode: "NZD",
    currencyName: "New Zealand dollar",
    name: "New Zealand",
    iso3Code: "NZL",
  ),
  Country(
    isoCode: "NI",
    currencyCode: "NIO",
    currencyName: "Nicaraguan córdoba",
    name: "Nicaragua",
    iso3Code: "NIC",
  ),
  Country(
    isoCode: "NE",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Niger",
    iso3Code: "NER",
  ),
  Country(
    isoCode: "NG",
    currencyCode: "NGN",
    currencyName: "Nigerian naira",
    name: "Nigeria",
    iso3Code: "NGA",
  ),
  Country(
    isoCode: "NU",
    currencyCode: "NZD",
    currencyName: "New Zealand dollar",
    name: "Niue",
    iso3Code: "NIU",
  ),
  Country(
    isoCode: "NF",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Norfolk Island",
    iso3Code: "NFK",
  ),
  Country(
    isoCode: "KP",
    currencyCode: "KPW",
    currencyName: "North Korean won",
    name: "Korea (Democratic People's Republic of)",
    iso3Code: "PRK",
  ),
  Country(
    isoCode: "MP",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Northern Mariana Islands",
    iso3Code: "MNP",
  ),
  Country(
    isoCode: "NO",
    currencyCode: "NOK",
    currencyName: "Norwegian krone",
    name: "Norway",
    iso3Code: "NOR",
  ),
  Country(
    isoCode: "OM",
    currencyCode: "OMR",
    currencyName: "Omani rial",
    name: "Oman",
    iso3Code: "OMN",
  ),
  Country(
    isoCode: "PK",
    currencyCode: "PKR",
    currencyName: "Pakistani rupee",
    name: "Pakistan",
    iso3Code: "PAK",
  ),
  Country(
    isoCode: "PW",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Palau",
    iso3Code: "PLW",
  ),
  Country(
    isoCode: "PS",
    currencyCode: "ILS",
    currencyName: "Israeli new sheqel",
    name: "Palestine, State of",
    iso3Code: "PSE",
  ),
  Country(
    isoCode: "PA",
    currencyCode: "PAB",
    currencyName: "Panamanian balboa",
    name: "Panama",
    iso3Code: "PAN",
  ),
  Country(
    isoCode: "PG",
    currencyCode: "PGK",
    currencyName: "Papua New Guinean kina",
    name: "Papua New Guinea",
    iso3Code: "PNG",
  ),
  Country(
    isoCode: "PY",
    currencyCode: "PYG",
    currencyName: "Paraguayan guaraní",
    name: "Paraguay",
    iso3Code: "PRY",
  ),
  Country(
    isoCode: "PE",
    currencyCode: "PEN",
    currencyName: "Peruvian sol",
    name: "Peru",
    iso3Code: "PER",
  ),
  Country(
    isoCode: "PH",
    currencyCode: "PHP",
    currencyName: "Philippine peso",
    name: "Philippines",
    iso3Code: "PHL",
  ),
  Country(
    isoCode: "PN",
    currencyCode: "NZD",
    currencyName: "New Zealand dollar",
    name: "Pitcairn",
    iso3Code: "PCN",
  ),
  Country(
    isoCode: "PL",
    currencyCode: "PLN",
    currencyName: "Polish złoty",
    name: "Poland",
    iso3Code: "POL",
  ),
  Country(
    isoCode: "PT",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Portugal",
    iso3Code: "PRT",
  ),
  Country(
    isoCode: "PR",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Puerto Rico",
    iso3Code: "PRI",
  ),
  Country(
    isoCode: "QA",
    currencyCode: "QAR",
    currencyName: "Qatari riyal",
    name: "Qatar",
    iso3Code: "QAT",
  ),
  Country(
    isoCode: "XK",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Republic of Kosovo",
    iso3Code: "KOS",
  ),
  Country(
    isoCode: "RE",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Réunion",
    iso3Code: "REU",
  ),
  Country(
    isoCode: "RO",
    currencyCode: "RON",
    currencyName: "Romanian leu",
    name: "Romania",
    iso3Code: "ROU",
  ),
  Country(
    isoCode: "RU",
    currencyCode: "RUB",
    currencyName: "Russian ruble",
    name: "Russian Federation",
    iso3Code: "RUS",
  ),
  Country(
    isoCode: "RW",
    currencyCode: "RWF",
    currencyName: "Rwandan franc",
    name: "Rwanda",
    iso3Code: "RWA",
  ),
  Country(
    isoCode: "BL",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Saint Barthélemy",
    iso3Code: "BLM",
  ),
  Country(
    isoCode: "SH",
    currencyCode: "SHP",
    currencyName: "Saint Helena pound",
    name: "Saint Helena, Ascension and Tristan da Cunha",
    iso3Code: "SHN",
  ),
  Country(
    isoCode: "KN",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Saint Kitts and Nevis",
    iso3Code: "KNA",
  ),
  Country(
    isoCode: "LC",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Saint Lucia",
    iso3Code: "LCA",
  ),
  Country(
    isoCode: "MF",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Saint Martin (French part)",
    iso3Code: "MAF",
  ),
  Country(
    isoCode: "PM",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Saint Pierre and Miquelon",
    iso3Code: "SPM",
  ),
  Country(
    isoCode: "VC",
    currencyCode: "XCD",
    currencyName: "East Caribbean dollar",
    name: "Saint Vincent and the Grenadines",
    iso3Code: "VCT",
  ),
  Country(
    isoCode: "WS",
    currencyCode: "WST",
    currencyName: "Samoan tālā",
    name: "Samoa",
    iso3Code: "WSM",
  ),
  Country(
    isoCode: "SM",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "San Marino",
    iso3Code: "SMR",
  ),
  Country(
    isoCode: "ST",
    currencyCode: "STD",
    currencyName: "São Tomé and Príncipe dobra",
    name: "Sao Tome and Principe",
    iso3Code: "STP",
  ),
  Country(
    isoCode: "SA",
    currencyCode: "SAR",
    currencyName: "Saudi riyal",
    name: "Saudi Arabia",
    iso3Code: "SAU",
  ),
  Country(
    isoCode: "SN",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Senegal",
    iso3Code: "SEN",
  ),
  Country(
    isoCode: "RS",
    currencyCode: "RSD",
    currencyName: "Serbian dinar",
    name: "Serbia",
    iso3Code: "SRB",
  ),
  Country(
    isoCode: "SC",
    currencyCode: "SCR",
    currencyName: "Seychellois rupee",
    name: "Seychelles",
    iso3Code: "SYC",
  ),
  Country(
    isoCode: "SL",
    currencyCode: "SLL",
    currencyName: "Sierra Leonean leone",
    name: "Sierra Leone",
    iso3Code: "SLE",
  ),
  Country(
    isoCode: "SG",
    currencyCode: "SGD",
    currencyName: "Singapore dollar",
    name: "Singapore",
    iso3Code: "SGP",
  ),
  Country(
    isoCode: "SX",
    currencyCode: "ANG",
    currencyName: "Netherlands Antillean guilder",
    name: "Sint Maarten (Dutch part)",
    iso3Code: "SXM",
  ),
  Country(
    isoCode: "SK",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Slovakia",
    iso3Code: "SVK",
  ),
  Country(
    isoCode: "SI",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Slovenia",
    iso3Code: "SVN",
  ),
  Country(
    isoCode: "SB",
    currencyCode: "SBD",
    currencyName: "Solomon Islands dollar",
    name: "Solomon Islands",
    iso3Code: "SLB",
  ),
  Country(
    isoCode: "SO",
    currencyCode: "SOS",
    currencyName: "Somali shilling",
    name: "Somalia",
    iso3Code: "SOM",
  ),
  Country(
    isoCode: "ZA",
    currencyCode: "ZAR",
    currencyName: "South African rand",
    name: "South Africa",
    iso3Code: "ZAF",
  ),
  Country(
    isoCode: "GS",
    currencyCode: "GBP",
    currencyName: "British pound",
    name: "South Georgia and the South Sandwich Islands",
    iso3Code: "SGS",
  ),
  Country(
    isoCode: "KR",
    currencyCode: "KRW",
    currencyName: "South Korean won",
    name: "Korea (Republic of)",
    iso3Code: "KOR",
  ),
  Country(
    isoCode: "SS",
    currencyCode: "SSP",
    currencyName: "South Sudanese pound",
    name: "South Sudan",
    iso3Code: "SSD",
  ),
  Country(
    isoCode: "ES",
    currencyCode: "EUR",
    currencyName: "Euro",
    name: "Spain",
    iso3Code: "ESP",
  ),
  Country(
    isoCode: "LK",
    currencyCode: "LKR",
    currencyName: "Sri Lankan rupee",
    name: "Sri Lanka",
    iso3Code: "LKA",
  ),
  Country(
    isoCode: "SD",
    currencyCode: "SDG",
    currencyName: "Sudanese pound",
    name: "Sudan",
    iso3Code: "SDN",
  ),
  Country(
    isoCode: "SR",
    currencyCode: "SRD",
    currencyName: "Surinamese dollar",
    name: "Suriname",
    iso3Code: "SUR",
  ),
  Country(
    isoCode: "SJ",
    currencyCode: "NOK",
    currencyName: "Norwegian krone",
    name: "Svalbard and Jan Mayen",
    iso3Code: "SJM",
  ),
  Country(
    isoCode: "SZ",
    currencyCode: "SZL",
    currencyName: "Swazi lilangeni",
    name: "Swaziland",
    iso3Code: "SWZ",
  ),
  Country(
    isoCode: "SE",
    currencyCode: "SEK",
    currencyName: "Swedish krona",
    name: "Sweden",
    iso3Code: "SWE",
  ),
  Country(
    isoCode: "CH",
    currencyCode: "CHF",
    currencyName: "Swiss franc",
    name: "Switzerland",
    iso3Code: "CHE",
  ),
  Country(
    isoCode: "SY",
    currencyCode: "SYP",
    currencyName: "Syrian pound",
    name: "Syrian Arab Republic",
    iso3Code: "SYR",
  ),
  Country(
    isoCode: "TW",
    currencyCode: "TWD",
    currencyName: "New Taiwan dollar",
    name: "Taiwan",
    iso3Code: "TWN",
  ),
  Country(
    isoCode: "TJ",
    currencyCode: "TJS",
    currencyName: "Tajikistani somoni",
    name: "Tajikistan",
    iso3Code: "TJK",
  ),
  Country(
    isoCode: "TZ",
    currencyCode: "TZS",
    currencyName: "Tanzanian shilling",
    name: "Tanzania, United Republic of",
    iso3Code: "TZA",
  ),
  Country(
    isoCode: "TH",
    currencyCode: "THB",
    currencyName: "Thai baht",
    name: "Thailand",
    iso3Code: "THA",
  ),
  Country(
    isoCode: "TL",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Timor-Leste",
    iso3Code: "TLS",
  ),
  Country(
    isoCode: "TG",
    currencyCode: "XOF",
    currencyName: "West African CFA franc",
    name: "Togo",
    iso3Code: "TGO",
  ),
  Country(
    isoCode: "TK",
    currencyCode: "NZD",
    currencyName: "New Zealand dollar",
    name: "Tokelau",
    iso3Code: "TKL",
  ),
  Country(
    isoCode: "TO",
    currencyCode: "TOP",
    currencyName: "Tongan paʻanga",
    name: "Tonga",
    iso3Code: "TON",
  ),
  Country(
    isoCode: "TT",
    currencyCode: "TTD",
    currencyName: "Trinidad and Tobago dollar",
    name: "Trinidad and Tobago",
    iso3Code: "TTO",
  ),
  Country(
    isoCode: "TN",
    currencyCode: "TND",
    currencyName: "Tunisian dinar",
    name: "Tunisia",
    iso3Code: "TUN",
  ),
  Country(
    isoCode: "TR",
    currencyCode: "TRY",
    currencyName: "Turkish lira",
    name: "Turkey",
    iso3Code: "TUR",
  ),
  Country(
    isoCode: "TM",
    currencyCode: "TMT",
    currencyName: "Turkmenistan manat",
    name: "Turkmenistan",
    iso3Code: "TKM",
  ),
  Country(
    isoCode: "TC",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "Turks and Caicos Islands",
    iso3Code: "TCA",
  ),
  Country(
    isoCode: "TV",
    currencyCode: "AUD",
    currencyName: "Australian dollar",
    name: "Tuvalu",
    iso3Code: "TUV",
  ),
  Country(
    isoCode: "UG",
    currencyCode: "UGX",
    currencyName: "Ugandan shilling",
    name: "Uganda",
    iso3Code: "UGA",
  ),
  Country(
    isoCode: "UA",
    currencyCode: "UAH",
    currencyName: "Ukrainian hryvnia",
    name: "Ukraine",
    iso3Code: "UKR",
  ),
  Country(
    isoCode: "AE",
    currencyCode: "AED",
    currencyName: "United Arab Emirates dirham",
    name: "United Arab Emirates",
    iso3Code: "ARE",
  ),
  Country(
    isoCode: "GB",
    currencyCode: "GBP",
    currencyName: "British pound",
    name: "United Kingdom of Great Britain and Northern Ireland",
    iso3Code: "GBR",
  ),
  Country(
    isoCode: "US",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "United States of America",
    iso3Code: "USA",
  ),
  Country(
    isoCode: "UY",
    currencyCode: "UYU",
    currencyName: "Uruguayan peso",
    name: "Uruguay",
    iso3Code: "URY",
  ),
  Country(
    isoCode: "UZ",
    currencyCode: "UZS",
    currencyName: "Uzbekistani so'm",
    name: "Uzbekistan",
    iso3Code: "UZB",
  ),
  Country(
    isoCode: "VU",
    currencyCode: "VUV",
    currencyName: "Vanuatu vatu",
    name: "Vanuatu",
    iso3Code: "VUT",
  ),
  Country(
    isoCode: "VE",
    currencyCode: "VEF",
    currencyName: "Venezuelan bolívar",
    name: "Venezuela (Bolivarian Republic of)",
    iso3Code: "VEN",
  ),
  Country(
    isoCode: "VN",
    currencyCode: "VND",
    currencyName: "Vietnamese đồng",
    name: "Viet Nam",
    iso3Code: "VNM",
  ),
  Country(
    isoCode: "WF",
    currencyCode: "XPF",
    currencyName: "CFP franc",
    name: "Wallis and Futuna",
    iso3Code: "WLF",
  ),
  Country(
    isoCode: "EH",
    currencyCode: "MAD",
    currencyName: "Moroccan dirham",
    name: "Western Sahara",
    iso3Code: "ESH",
  ),
  Country(
    isoCode: "YE",
    currencyCode: "YER",
    currencyName: "Yemeni rial",
    name: "Yemen",
    iso3Code: "YEM",
  ),
  Country(
    isoCode: "ZM",
    currencyCode: "ZMW",
    currencyName: "Zambian kwacha",
    name: "Zambia",
    iso3Code: "ZMB",
  ),
  Country(
    isoCode: "ZW",
    currencyCode: "BWP",
    currencyName: "Botswana pula",
    name: "Zimbabwe",
    iso3Code: "ZWE",
  ),
];

const currencires = {
  'AFN': 'Af.',
  'TOP': r'T$',
  'MGA': 'Ar',
  'THB': '\u0e3f',
  'PAB': 'B/.',
  'ETB': 'Birr',
  'VEF': 'Bs',
  'BOB': 'Bs',
  'GHS': 'GHS',
  'CRC': '\u20a1',
  'NIO': r'C$',
  'GMD': 'GMD',
  'MKD': 'din',
  'BHD': 'din',
  'DZD': 'din',
  'IQD': 'din',
  'JOD': 'din',
  'KWD': 'din',
  'LYD': 'din',
  'RSD': 'din',
  'TND': 'din',
  'AED': 'dh',
  'MAD': 'dh',
  'STD': 'Db',
  'BSD': r'$',
  'FJD': r'$',
  'GYD': r'$',
  'KYD': r'$',
  'LRD': r'$',
  'SBD': r'$',
  'SRD': r'$',
  'AUD': r'$',
  'BBD': r'$',
  'BMD': r'$',
  'BND': r'$',
  'BZD': r'$',
  'CAD': r'$',
  'HKD': r'$',
  'JMD': r'$',
  'NAD': r'$',
  'NZD': r'$',
  'SGD': r'$',
  'TTD': r'$',
  'TWD': r'NT$',
  'USD': r'$',
  'XCD': r'$',
  'VND': '\u20ab',
  'AMD': 'Dram',
  'CVE': 'CVE',
  'EUR': '\u20ac',
  'AWG': 'Afl.',
  'HUF': 'Ft',
  'BIF': 'FBu',
  'CDF': 'FrCD',
  'CHF': 'CHF',
  'DJF': 'Fdj',
  'GNF': 'FG',
  'RWF': 'RF',
  'XOF': 'CFA',
  'XPF': 'FCFP',
  'KMF': 'CF',
  'XAF': 'FCFA',
  'HTG': 'HTG',
  'PYG': 'Gs',
  'UAH': '\u20b4',
  'PGK': 'PGK',
  'LAK': '\u20ad',
  'CZK': 'K\u010d',
  'SEK': 'kr',
  'ISK': 'kr',
  'DKK': 'kr',
  'NOK': 'kr',
  'HRK': 'kn',
  'MWK': 'MWK',
  'ZMK': 'ZWK',
  'AOA': 'Kz',
  'MMK': 'K',
  'GEL': 'GEL',
  'LVL': 'Ls',
  'ALL': 'Lek',
  'HNL': 'L',
  'SLL': 'SLL',
  'MDL': 'MDL',
  'RON': 'RON',
  'BGN': 'lev',
  'SZL': 'SZL',
  'TRY': 'TL',
  'LTL': 'Lt',
  'LSL': 'LSL',
  'AZN': 'man.',
  'BAM': 'KM',
  'MZN': 'MTn',
  'NGN': '\u20a6',
  'ERN': 'Nfk',
  'BTN': 'Nu.',
  'MRO': 'MRO',
  'MOP': 'MOP',
  'CUP': r'$',
  'CUC': r'$',
  'ARS': r'$',
  'CLF': 'UF',
  'CLP': r'$',
  'COP': r'$',
  'DOP': r'$',
  'MXN': r'$',
  'PHP': '\u20b1',
  'UYU': r'$',
  'FKP': '£',
  'GIP': '£',
  'SHP': '£',
  'EGP': 'E£',
  'LBP': 'L£',
  'SDG': 'SDG',
  'SSP': 'SSP',
  'GBP': '£',
  'SYP': '£',
  'BWP': 'P',
  'GTQ': 'Q',
  'ZAR': 'R',
  'BRL': r'R$',
  'OMR': 'Rial',
  'QAR': 'Rial',
  'YER': 'Rial',
  'IRR': 'Rial',
  'KHR': 'Riel',
  'MYR': 'RM',
  'SAR': 'Riyal',
  'BYR': 'BYR',
  'RUB': 'руб.',
  'MUR': 'Rs',
  'SCR': 'SCR',
  'LKR': 'Rs',
  'NPR': 'Rs',
  'INR': '\u20b9',
  'PKR': 'Rs',
  'IDR': 'Rp',
  'ILS': '\u20aa',
  'KES': 'Ksh',
  'SOS': 'SOS',
  'TZS': 'TSh',
  'UGX': 'UGX',
  'PEN': 'S/.',
  'KGS': 'KGS',
  'UZS': 'so\u02bcm',
  'TJS': 'Som',
  'BDT': '\u09f3',
  'WST': 'WST',
  'KZT': '\u20b8',
  'MNT': '\u20ae',
  'VUV': 'VUV',
  'KPW': '\u20a9',
  'KRW': '\u20a9',
  'JPY': '¥',
  'CNY': '¥',
  'PLN': 'z\u0142',
  'MVR': 'Rf',
  'NLG': 'NAf',
  'ZMW': 'ZK',
  'ANG': 'ƒ',
  'TMT': 'TMT',
};
