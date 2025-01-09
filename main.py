from queue import Empty
import random
from faker import Faker
from datetime import datetime, timedelta
import pandas as pd
from faker.providers import BaseProvider

### rzeczy do zmienienia w create.sql :
# dodanie AUTOINCREMENT do id w tabelach, które nie maja FK jako PK
# w orderDetails, pk to orderID, productID, a nie samo orderID, jesli moze byc kilka produktow w jendym order
# dodac tablice course participants
#courseDetails  ma title, mimo że courseName istnieje w course?
# Ammount parameters:
participants_ammount = 10000
employees_amount = 1000
product_ammount = 1000


# Provider for phone numbers in the same format ###-###-####

class PhoneProvider(BaseProvider):
    def phone(self):
        first = str(random.randint(100,999))
        second = str(random.randint(1,888)).zfill(3)

        last = (str(random.randint(1,9998)).zfill(4))
        while last in ['1111','2222','3333','4444','5555','6666','7777','8888']:
            last = (str(random.randint(1,9998)).zfill(4))
            
        return f'{first}-{second}-{last}'

fake = Faker(locale="en_US")
fake.add_provider(PhoneProvider)

# Generate random employee data
employee_list = []
for i in range(employees_amount):
    employee = {
        "firstName": fake.first_name(),
        "middleName": fake.first_name(),
        "lastName": fake.last_name(),
        "phone": fake.phone(),
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

# Generate translatorDetails data
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
language_details_df.to_csv('data/translatorDetails.csv', index=False)

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
participant_schedule = [[] for i in range(participants_ammount)]
for i in range (participants_ammount):
    participant = {
        "firstName": fake.first_name(),
        "middleName": fake.first_name(),
        "lastName": fake.last_name(),
        "email": fake.email(),
        "phone": fake.phone(),
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
        "supervisorID": fake.random_int(min=0, max=employees_amount - 1)
    }
    major_list.append(major)
major_df = pd.DataFrame(major_list)
major_df.to_csv('data/major.csv', index=False)

# Generate syllabus data
syllabus_list = []
for i in range (len(majors)):
        term_number = 8
        for j in range (1, term_number + 1):
            for subject_id in fake.random_elements(elements=range(subjects_length), length=fake.random_int(min=4, max=7)):
                syllabus = {
                    "majorID": i,
                    "subjectID": subject_id,
                    "requiredHours": fake.random_int(min=1, max=4) * 15,
                    "term": j,
                }
                syllabus_list.append(syllabus)
syllabus_df = pd.DataFrame(syllabus_list)
syllabus_df.to_csv('data/syllabus.csv', index=False)

#Generate productTypes
product_types = ["Webinar", "Course", "Studies"]
product_types_df = pd.DataFrame(product_types, columns=['typeName'])
product_types_df.to_csv('data/productTypes.csv', index=False)

# Generate product data
product_list = []

#will be used for generating diffrent tables (orders, classes, courses...)
product_time_start_end = []
for i in range(product_ammount):
    product = {
        "isAvailable": fake.random_int(min=0, max=1),
        "typeID": random.choices([0, 1, 2], weights=[50, 40, 10], k=1)[0],
    }
    match product['typeID']:
        case 0: #webinar
            start_date = fake.date_time_between(start_date='-6y', end_date='+1M')
            end_date = start_date + timedelta(hours=1, minutes=30)
            product_time_start_end.append((
                start_date,
                end_date
            ))
        case 1: #course
            start_date = fake.date_time_between(start_date='-6y', end_date='+1M')
            end_date = start_date + timedelta(days=fake.random_int(min=4, max=7))
            product_time_start_end.append((
                start_date,
                end_date
            ))
        case 2: #studies
            start_date = fake.date_time_between(start_date='-6y', end_date='+1y')
            end_date = start_date + timedelta(days=4*365)
            product_time_start_end.append((
                start_date,
                end_date
            ))

    product_list.append(product)
product_df = pd.DataFrame(product_list)
product_df.to_csv('data/products.csv', index=False)

# Generate class data
relatedProduct_ids = [i for i in range(product_ammount) if product_list[i]['typeID'] == 2]
class_list = []

class_ammount = len(relatedProduct_ids)
for i in range(class_ammount):
    if product_time_start_end[i][0] > datetime.now():
        class_ammount -= 1
        continue
    year = product_time_start_end[i][0].year
    class_data = {
        "year" : year,
        "limit" : fake.random_int(min=30, max=100),
        "majorID" : fake.random_int(min=0, max=len(majors) - 1),
        "productID" : relatedProduct_ids[i],
        "languageID"   :  fake.random_int(min=0, max=len(languages) - 1),
        # 0 if class is in the past
        "term": ((2025 - year) * 2 + 1 if year > 2021 else 0),
        "price": (fake.random_int(min=1000000, max=30000000)/100),
    }
    class_list.append(class_data)
class_df = pd.DataFrame(class_list)
class_df.to_csv('data/class.csv', index=False)


# Generate students
remaining_participant_ids = [i for i in range (participants_ammount)] 
students = []
for i in range (class_ammount):
    students_in_this_class = fake.random_int(min=class_df['limit'][i]-10,max=class_df['limit'][i])
    for j in range(students_in_this_class):
        
        try:
            student_id = remaining_participant_ids.pop(fake.random_int(min=0, max=len(remaining_participant_ids) - 1))
            student = {
                "courseID": i,
                "studentID": student_id, 
            }
        except:
            print("Not enough participants")
        
        participant_schedule[student_id].append(product_time_start_end[relatedProduct_ids[i]]) #add class time frame so that events dont overlap
        students.append(student)
students_df = pd.DataFrame(students)
students_df.to_csv('data/students.csv', index=False)


# Generate course data
relatedProduct_ids = [i for i in range(product_ammount) if product_list[i]['typeID'] == 1]
course_list = []
course_ammount = len(relatedProduct_ids)
for i in range(course_ammount):
    date = product_time_start_end[relatedProduct_ids[i]][0]
    if date > datetime.now():
        course_ammount -= 1
        continue
    course_data = {
        "productID" : relatedProduct_ids[i],
        "courseName" : "Course on " + subjects['subjectName'][fake.random_int(min=0, max=subjects_length - 1)] + ", edition: " + fake.random_element(["I", "II", "III", "IV"]),
        "price": fake.random_int(min=20000, max=300000)/100,
        "advancePrice": fake.random_int(min=10000, max=150000)/100,
        "limit" : fake.random_int(min=30, max=60) if fake.random_int(min=0, max=5) == 0 else None,

    }
    course_list.append(course_data)
course_df = pd.DataFrame(course_list)
course_df.to_csv('data/course.csv', index=False)


# Generate courseDetails data
course_details_list = []
for i in range(course_ammount):
    course_details = {
        "courseID": relatedProduct_ids[i],
        "description": fake.text(),
        "languageID": fake.random_int(min=0, max=len(languages) - 1),
    }
    course_details_list.append(course_details)
course_details_df = pd.DataFrame(course_details_list)
course_details_df.to_csv('data/courseDetails.csv', index=False)

# Generate courseParticipants
###remaining participants are defined and updated in class generation in order not to assign them to any course
course_participants = []
for i in range (course_ammount):
    course_limit = course_df['limit'][i]
    course_participants_in_this_course = 50 if pd.isna(course_limit) else fake.random_int(min=int(course_limit-10), max=int(course_limit)) #50 for convenience)
    for j in range(course_participants_in_this_course):
        
        try:
            student_id = remaining_participant_ids[(fake.random_int(min=0, max=len(remaining_participant_ids) - 1))]
            student = {
                "courseID": i,
                "studentID": student_id, 
            }
        except:
            print("Not enough participants")
        course_time = product_time_start_end[relatedProduct_ids[i]]
        doesColide = False
        for existing_time in participant_schedule[student_id]:
            if course_time[0] < existing_time[1] and course_time[1] > existing_time[0]:
                doesColide = True
                break
        if doesColide == True: continue
        participant_schedule[student_id].append(product_time_start_end[relatedProduct_ids[i]]) #add class time frame so that events dont overlap
        course_participants.append(student)
course_participants_df = pd.DataFrame(course_participants)
course_participants_df.to_csv('data/courseParticipants.csv', index=False)

# Generate webinar data
relatedProduct_ids = [i for i in range(product_ammount) if product_list[i]['typeID'] == 0]
webinar_list = []
webinar_ammount = len(relatedProduct_ids)
for i in range(webinar_ammount):
    webinar_data = {
        "productID" : relatedProduct_ids[i],
        "webinarName" : "Webinar on " + subjects['subjectName'][fake.random_int(min=0, max=subjects_length - 1)] + ", edition: " + fake.random_element(["I", "II", "III", "IV"]),
        "price": fake.random_int(min=1000, max=10000)/100,
    }
    webinar_list.append(webinar_data)
webinar_df = pd.DataFrame(webinar_list)
webinar_df.to_csv('data/webinar.csv', index=False)

# Generate webinarDetails data
webinar_details_list = []
for i in range(webinar_ammount):
    language = fake.random_int(min=0, max=len(languages) - 1)
    for translator in translators_df['translator_id']:
        if language in language_details_df[language_details_df['translatorID'] == translator]['languageID'].values:
            break
    webinar_details = {
        "instructorID": fake.random_int(min=0, max=employees_amount - 1),
        "meetingLink": fake.url(),
        "recordingLink": fake.url(),
        "description": fake.text(),
        "translatorID": translator,
        "languageID": language
    }
    webinar_details_list.append(webinar_details)
webinar_details_df = pd.DataFrame(webinar_details_list)
webinar_details_df.to_csv('data/webinarDetails.csv', index=False)

# Generate webinarParticipants
# CREATE TABLE webinarParticipants (
#     webinarID int  NOT NULL,
#     participantID int  NOT NULL,
#     accessUntill datetime  NOT NULL,
#     CONSTRAINT webinarParticipants_pk PRIMARY KEY (webinarID,participantID)
# );
webinar_participants = []
for i in range (webinar_ammount):
    webinar_participants_in_this_webinar = fake.random_int(min=30, max=60) #numbers chosen for convenience
    for j in range(webinar_participants_in_this_webinar):
        
        try:
            student_id = remaining_participant_ids[(fake.random_int(min=0, max=len(remaining_participant_ids) - 1))]
            student = {
                "webinarID": i,
                "participantID": student_id, 
            }
        except:
            print("Not enough participants")
        webinar_time = product_time_start_end[relatedProduct_ids[i]]
        doesColide = False
        for existing_time in participant_schedule[student_id]:
            if webinar_time[0] < existing_time[1] and webinar_time[1] > existing_time[0]:
                doesColide = True
                break
        if doesColide == True: continue
        participant_schedule[student_id].append(product_time_start_end[relatedProduct_ids[i]]) #add class time frame so that events dont overlap
        webinar_participants.append(student)
webinar_participants_df = pd.DataFrame(webinar_participants)
webinar_participants_df.to_csv('data/webinarParticipants.csv', index=False)
# Generate building data

building_list = []
buildings_ammount = 10
for i in range(buildings_ammount):
    building = {
        "address": fake.address(),
    }
    building_list.append(building)
building_df = pd.DataFrame(building_list)
building_df.to_csv('data/building.csv', index=False)

# Generate room data
room_list = []
rooms_ammount = 100
for i in range(rooms_ammount):
    room = {
        "buildingID": fake.random_int(min=0, max=buildings_ammount - 1),
        "roomNumber": fake.random_int(min=100, max=999),
        "size": fake.random_int(min=20, max=50),
    }
    room_list.append(room)
room_df = pd.DataFrame(room_list)
room_df.to_csv('data/rooms.csv', index=False)



#generate random orders data ###NIE SKONCZONE###

orders_list = []
remaining_participant_ids = [i for i in range (participants_ammount)] # (participants_ammount is the number of all participants)
student_ids = remaining_participant_ids[len(remaining_participant_ids)//3:]
remaining_participant_ids = [i for i in remaining_participant_ids if i not in student_ids]
order_dates = []
# orders for studies:
for i in student_ids:
    order = {
        "participantID": i,
        "paymentLink": fake.url(),
        "orderDate": fake.date_time_between(start_date='-6y', end_date='now'),
    }
    order_dates.append(order['orderDate'])
    orders_list.append(order)

# orders for courses:
course_students_ids = remaining_participant_ids[:len(remaining_participant_ids)//2]
remaining_participant_ids = [i for i in remaining_participant_ids if i not in course_students_ids]
for i in course_students_ids:
    order = {
        "participantID": i,
        "paymentLink": fake.url(),
        "orderDate": fake.date_time_between(start_date='-6y', end_date='now'),
    }
    order_dates.append(order['orderDate'])
    orders_list.append(order)








