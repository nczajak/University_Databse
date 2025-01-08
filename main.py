from faker import Faker
import pandas as pd

fake = Faker(locale="en_US")


# Generate random employee data
AMMOUNT = 100
employee_list = []
for i in range(AMMOUNT):
    employee = {
        "firstName": fake.first_name(),
        "middleName": fake.first_name(),
        "lastName": fake.last_name(),
        "phone": fake.phone_number(),
        "email": fake.email(),
        "address": fake.address(),
    }
    employee_list.append(employee)

# Convert to DataFrame
df = pd.DataFrame(employee_list)
df.to_csv('data/employees.csv', index=False)

# Generate titles
titles = ["professor", "assistant professor", "lecturer", "senior lecturer", "associate professor", "adjunct professor", "visiting professor", "instructor", "president"]
titles_df = pd.DataFrame(titles, columns=['titleID'])

titles_df.to_csv('data/titles.csv', index=False)

# Generate random translator data
translator_ids = df.sample(frac=0.1)
translators = {
    "translator_id": translator_ids.index,
}

translators_df = pd.DataFrame(translators)
translators_df.to_csv('data/translator.csv', index=False)
df.drop(translator_ids.index, inplace=True)

# Generate language data
languages = ["English", "Spanish", "French", "German", "Italian", "Portuguese", "Dutch", "Russian",
              "Chinese", "Japanese", "Korean", "Arabic", "Turkish", "Persian", "Hindi", "Urdu", "Bengali",
                "Punjabi", "Telugu", "Marathi", "Tamil", "Gujarati", "Kannada", "Odia", "Malayalam", "Sindhi",
                  "Nepali", "Sinhala", "Burmese", "Khmer", "Lao", "Thai", "Vietnamese", "Indonesian", "Filipino",
                    "Malay", "Javanese", "Sundanese", "Hausa", "Yoruba", "Igbo", "Fulfulde", "Swahili", "Amharic",
                      "Oromo", "Somali", "Tigrinya", "Kinyarwanda", "Kirundi", "Luganda", "Kikuyu", "Kinyamulenge",
                        "Lingala", "Kiswahili", "Chichewa", "Zulu", "Xhosa", "Afrikaans", "Sotho", "Tswana", "Ndebele",
                          "Shona", "Polish", "Ukrainian", "Czech", "Slovak", "Hungarian", "Romanian", "Bulgarian",]
languages = [{"languageName": language} for language in languages]
languages_df = pd.DataFrame(languages)
languages_df.to_csv('data/languages.csv', index=False)

# Generate languageDetails data
language_details = []
for translator_id in translators_df['translator_id']:
    num_languages = fake.random_int(min=1, max=4)
    assigned_languages = set()
    while len(assigned_languages) < num_languages:
        assigned_languages.add(fake.random_int(min=0, max=len(languages) - 1))
    for language in assigned_languages:
        detail = {
            "translatorID": translator_id,
            "languageID": language,
        }
        language_details.append(detail)

language_details_df = pd.DataFrame(language_details)
language_details_df.to_csv('data/languageDetails.csv', index=False)
# Generate random instructor data
instructor_ids = df.sample(frac=0.9)
instructors = {
    "instructorID": instructor_ids.index,
    "titleID": [fake.random_element(titles[0:7]) for _ in range(len(instructor_ids))]
}
instructors_df = pd.DataFrame(instructors)
instructors_df.to_csv('data/instructors.csv', index=False)

# Generate president data
remaining_ids = df.drop(instructor_ids.index)
president = remaining_ids.sample(n=1)
president_data = {
    "presidentID": president.index[0],
    "titleID": titles[8]
}
president_df = pd.DataFrame([president_data])
president_df.to_csv('data/president.csv', index=False)

# Generate random internship supervisor data
remaining_ids = remaining_ids.drop(president.index)
internship_supervisors = {
    "internshipSupervisorID": remaining_ids.index,
}

internship_supervisors = pd.DataFrame(internship_supervisors)
internship_supervisors.to_csv('data/internshipSupervisors.csv', index=False)

# Generate subjects 
subjects = ["Math", "Physics", "Chemistry", "Biology", "History", "Geography", "Literature", "Philosophy",
             "Economics", "Psychology", "Sociology", "Political Science", "Anthropology", "Computer Science",
             "Information Technology", "Business Administration", "Accounting", "Finance", "Marketing", "Management",
             "Human Resources", "Operations Management", "Supply Chain Management", "International Business", "Entrepreneurship",
             "Healthcare Management", "Public Administration", "Public Relations", "Journalism", "Communication", "Media Studies",
             "Criminal Justice", "Law", "Education", "Nursing", "Medicine", "Dentistry", "Pharmacy", "Physical Therapy",
             "Occupational Therapy", "Social Work", "Engineering", "Architecture", "Urban Planning", "Environmental Science"]
subjects_length = len(subjects)
subjects = [{"subjectName": subject, "description": fake.text()} for subject in subjects]
subjects = pd.DataFrame(subjects, columns=['subjectName', 'description'])
subjects.to_csv('data/subjects.csv', index=False)

# Generate instructorDetails
instructor_details = []

for instructor_id in instructors_df['instructorID']:
    num_subjects = fake.random_int(min=1, max=4)
    assigned_subjects = set()
    while len(assigned_subjects) < num_subjects:
        assigned_subjects.add(fake.random_int(min=0, max=subjects_length - 1))
    for subject in assigned_subjects:
        detail = {
            "instructorID": instructor_id,
            "subjectID": subject,
        }
        instructor_details.append(detail)

instructor_details_df = pd.DataFrame(instructor_details)
instructor_details_df.to_csv('data/instructorDetails.csv', index=False)

# Generate participant data
partcipant_list = []
for i in range (AMMOUNT*10):
    participant = {
        "firstName": fake.first_name(),
        "middleName": fake.first_name(),
        "lastName": fake.last_name(),
        "email": fake.email(),
        "phone": fake.phone_number(),
        "address": fake.address(),
    }
    partcipant_list.append(participant)
participant_df = pd.DataFrame(partcipant_list)
participant_df.to_csv('data/participants.csv', index=False)
# Generate major data
majors = ["Mathematics", "Physics", "Chemistry", "Biology", "History", "Geography", "Literature", "Philosophy",
             "Economics", "Psychology", "Sociology", "Political Science", "Anthropology", "Computer Science",
             "Information Technology", "Business Administration", "Accounting", "Finance", "Marketing", "Management",
             "Human Resources", "Operations Management", "Supply Chain Management", "International Business", "Entrepreneurship",
             "Healthcare Management", "Public Administration", "Public Relations", "Journalism", "Communication", "Media Studies",
             "Criminal Justice", "Law", "Education", "Nursing", "Medicine", "Dentistry", "Pharmacy", "Physical Therapy",
             "Occupational Therapy", "Social Work", "Engineering", "Architecture", "Urban Planning", "Environmental Science"]
major_list = []
for i in range(len(majors)):
    major = {
        "name": majors[i],
        "description": fake.text(),
        "supervisorID": fake.random_int(min=0, max=AMMOUNT - 1)
    }
    major_list.append(major)
major_df = pd.DataFrame(major_list)
major_df.to_csv('data/majors.csv', index=False)

#Generate productTypes
product_types = ["Webinar", "Course", "Studies"]
product_types_df = pd.DataFrame(product_types, columns=['typeName'])
product_types_df.to_csv('data/productTypes.csv', index=False)

# Generate product data
PRODUCT_AMMOUNT = AMMOUNT//3
product_list = []
for i in range(PRODUCT_AMMOUNT):
    product = {
        "name":fake.random_element(["Webinar", "Studies", "Course"]) + " on " + subjects['subjectName'][fake.random_int(min=0, max=subjects_length - 1)],
        "description": fake.text(),
        "typeID": fake.random_int(min=0, max=2),
    }
    product_list.append(product)
product_df = pd.DataFrame(product_list)
product_df.to_csv('data/products.csv', index=False)
# Generate class data
relatedProducts = [product for product in product_list if product['typeID'] == 2]
class_list = []
class_ammount = len(relatedProducts)
for i in range(class_ammount):
    year = fake.random_int(min=2019, max=2024)
    class_data = {
        "year" : year,
        "limit" : fake.random_int(min=30, max=100),
        "majorID" : fake.random_int(min=0, max=len(majors) - 1),
        "productID" : relatedProducts[i],
        "languageID"   :  fake.random_int(min=0, max=len(languages) - 1),
        # 0 if class is in the past
        "term": ((2025 - year) * 2 + fake.random_int(min=1, max=2) if year > 2020 else 0),

    }
    class_list.append(class_data)
class_df = pd.DataFrame(class_list)
class_df.to_csv('data/classes.csv', index=False)

