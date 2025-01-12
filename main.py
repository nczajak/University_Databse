import string
from queue import Empty
import random
from faker import Faker
from datetime import datetime, timedelta
import pandas as pd
from faker.providers import BaseProvider

### zmienic w bazie meetingMode - ja się tym zajmę
# w modułach ok 680 linijki daje losowe id bo nie  wiem jak wyciągać które id
# należą do kursów, więc  jak ktos wie to może poprawić
# id tabel liczymy od 0, poprawić generowanie losowych id (np w kluczach obcych)
# dodać conventions do products
# Zostało meetingParticipants i asyncMeetingDetails

### rzeczy do zmienienia w create.sql :
# dodanie AUTOINCREMENT do id w tabelach, które nie maja FK jako PK
# w orderDetails, pk to orderID, productID, a nie samo orderID, jesli moze byc kilka produktow w jendym order
# dodac tablice course participants
# courseDetails  ma title, mimo że courseName istnieje w course?

# Ammount parameters:

participants_ammount = 10000
employees_amount = 1000
product_ammount = 1000 # bez conventions
company_ammount = 30
meeting_amount = 4000
onlineSyncMeeting_amount = onlineAsyncMeeting_amount = 1000
stationary_meetings_amount = 2000
internship_amount = 100
module_amount = 500
convention_amount = 300


# Provider for phone numbers in the same format ###-###-####

class PhoneProvider(BaseProvider):
    def phone(self):
        first = str(random.randint(100, 999))
        second = str(random.randint(1, 888)).zfill(3)

        last = (str(random.randint(1, 9998)).zfill(4))
        while last in ['1111', '2222', '3333', '4444', '5555', '6666', '7777', '8888']:
            last = (str(random.randint(1, 9998)).zfill(4))

        return f'{first}-{second}-{last}'


fake = Faker(locale="en_US")
fake.add_provider(PhoneProvider)


def generate_random_string(length=10):
    letters = string.ascii_lowercase + string.digits
    return ''.join(random.choice(letters) for i in range(length))


class LinkProvider(BaseProvider):
    def link(self):
        domain = "www.learning.com"
        path = generate_random_string(12)
        random_link = f"http://{domain}/{path}"
        return random_link


fake.add_provider(LinkProvider)

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
titles = ["professor", "assistant professor", "lecturer", "senior lecturer", "associate professor", "adjunct professor",
          "visiting professor", "instructor", "president"]
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
             "Shona", "Polish", "Ukrainian", "Czech", "Slovak", "Hungarian", "Romanian", "Bulgarian", ]
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
            "Human Resources", "Operations Management", "Supply Chain Management", "International Business",
            "Entrepreneurship",
            "Healthcare Management", "Public Administration", "Public Relations", "Journalism", "Communication",
            "Media Studies",
            "Criminal Justice", "Law", "Education", "Nursing", "Medicine", "Dentistry", "Pharmacy", "Physical Therapy",
            "Occupational Therapy", "Social Work", "Engineering", "Architecture", "Urban Planning",
            "Environmental Science"]
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
for i in range(participants_ammount):
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
          "Human Resources", "Operations Management", "Supply Chain Management", "International Business",
          "Entrepreneurship",
          "Healthcare Management", "Public Administration", "Public Relations", "Journalism", "Communication",
          "Media Studies",
          "Criminal Justice", "Law", "Education", "Nursing", "Medicine", "Dentistry", "Pharmacy", "Physical Therapy",
          "Occupational Therapy", "Social Work", "Engineering", "Architecture", "Urban Planning",
          "Environmental Science"]
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
for i in range(len(majors)):
    term_number = 8
    for j in range(1, term_number + 1):
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

# Generate productTypes
product_types = ["Webinar", "Course", "Studies"]
product_types_df = pd.DataFrame(product_types, columns=['typeName'])
product_types_df.to_csv('data/productTypes.csv', index=False)

# Generate product data
product_list = []

# will be used for generating diffrent tables (orders, classes, courses...)
product_time_start_end = []
for i in range(product_ammount):
    product = {
        "isAvailable": fake.random_int(min=0, max=1),
        "typeID": random.choices([0, 1, 2], weights=[50, 40, 10], k=1)[0],
    }
    match product['typeID']:
        case 0:  # webinar
            start_date = fake.date_time_between(start_date='-6y', end_date='+1M')
            end_date = start_date + timedelta(hours=1, minutes=30)
            product_time_start_end.append((
                start_date,
                end_date
            ))
        case 1:  # course
            start_date = fake.date_time_between(start_date='-6y', end_date='+1M')
            end_date = start_date + timedelta(days=fake.random_int(min=4, max=7))
            product_time_start_end.append((
                start_date,
                end_date
            ))
        case 2:  # studies
            start_date = fake.date_time_between(start_date='-6y', end_date='+1y')
            end_date = start_date + timedelta(days=4 * 365)
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
class_to_product = []
product_price = [None for _ in range(product_ammount)]
class_ammount = len(relatedProduct_ids)
for i in range(class_ammount):
    if product_time_start_end[i][0] > datetime.now():
        class_ammount -= 1
        continue
    year = product_time_start_end[i][0].year
    class_data = {
        "year": year,
        "limit": fake.random_int(min=30, max=100),
        "majorID": fake.random_int(min=0, max=len(majors) - 1),
        "productID": relatedProduct_ids[i],
        "languageID": fake.random_int(min=0, max=len(languages) - 1),
        # 0 if class is in the past
        "term": ((2025 - year) * 2 + 1 if year > 2021 else 0),
        "price": (fake.random_int(min=1000000, max=30000000) / 100),
    }
    product_price[relatedProduct_ids[i]] = class_data['price']
    class_to_product.append(class_data['productID'])
    class_list.append(class_data)
class_df = pd.DataFrame(class_list)
class_df.to_csv('data/class.csv', index=False)

# Generate students
remaining_participant_ids = [i for i in range(participants_ammount)]
students = []
for i in range(class_ammount):
    students_in_this_class = fake.random_int(min=class_df['limit'][i] - 10, max=class_df['limit'][i])
    for j in range(students_in_this_class):

        try:
            student_id = remaining_participant_ids.pop(fake.random_int(min=0, max=len(remaining_participant_ids) - 1))
            student = {
                "classID": i,
                "studentID": student_id,
            }
        except:
            print("Not enough participants")

        participant_schedule[student_id].append(
            product_time_start_end[relatedProduct_ids[i]])  # add class time frame so that events dont overlap
        students.append(student)
students_df = pd.DataFrame(students)
students_df.to_csv('data/students.csv', index=False)

# Generate finalExam data
finalExam_list = []
for student in students:
    final_exam = {
        "classID": student['classID'],
        "participantID": student['studentID'],
        "passed": fake.random_element([None, 1, 0]),
    }
    finalExam_list.append(final_exam)
final_exam_df = pd.DataFrame(finalExam_list)
final_exam_df.to_csv('data/finalExam.csv', index=False)

# Generate course data
relatedProduct_ids = [i for i in range(product_ammount) if product_list[i]['typeID'] == 1]
course_list = []
course_to_product = []
course_ammount = len(relatedProduct_ids)
for i in range(course_ammount):
    date = product_time_start_end[relatedProduct_ids[i]][0]
    if date > datetime.now():
        course_ammount -= 1
        continue
    course_data = {
        "productID": relatedProduct_ids[i],
        "courseName": "Course on " + subjects['subjectName'][
            fake.random_int(min=0, max=subjects_length - 1)] + ", edition: " + fake.random_element(
            ["I", "II", "III", "IV"]),
        "price": fake.random_int(min=20000, max=300000) / 100,
        "advancePrice": fake.random_int(min=10000, max=150000) / 100,
        "limit": fake.random_int(min=30, max=60) if fake.random_int(min=0, max=5) == 0 else None,
    }
    product_price[relatedProduct_ids[i]] = course_data['price']
    course_to_product.append(course_data['productID'])
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
for i in range(course_ammount):
    course_limit = course_df['limit'][i]
    course_participants_in_this_course = 50 if pd.isna(course_limit) else fake.random_int(min=int(course_limit - 10),
                                                                                          max=int(
                                                                                              course_limit))  # 50 for convenience)
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
        participant_schedule[student_id].append(
            product_time_start_end[relatedProduct_ids[i]])  # add class time frame so that events dont overlap
        course_participants.append(student)
course_participants_df = pd.DataFrame(course_participants)
course_participants_df.to_csv('data/courseParticipants.csv', index=False)

# Generate webinar data
relatedProduct_ids = [i for i in range(product_ammount) if product_list[i]['typeID'] == 0]
webinar_list = []
wenbinar_to_product = []
webinar_ammount = len(relatedProduct_ids)
for i in range(webinar_ammount):
    webinar_data = {
        "productID": relatedProduct_ids[i],
        "webinarName": "Webinar on " + subjects['subjectName'][
            fake.random_int(min=0, max=subjects_length - 1)] + ", edition: " + fake.random_element(
            ["I", "II", "III", "IV"]),
        "price": fake.random_int(min=1000, max=10000) / 100,
    }
    product_price[relatedProduct_ids[i]] = webinar_data['price']
    wenbinar_to_product.append(webinar_data['productID'])
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
        "meetingLink": fake.link(),
        "recordingLink": fake.url(),
        "description": fake.text(),
        "translatorID": translator,
        "languageID": language
    }
    webinar_details_list.append(webinar_details)
webinar_details_df = pd.DataFrame(webinar_details_list)
webinar_details_df.to_csv('data/webinarDetails.csv', index=False)

# Generate webinarParticipants
webinar_participants = []
for i in range(webinar_ammount):
    webinar_participants_in_this_webinar = fake.random_int(min=30, max=60)  # numbers chosen for convenience
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
        participant_schedule[student_id].append(
            product_time_start_end[relatedProduct_ids[i]])  # add class time frame so that events dont overlap
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

# generate random orders data 

orders_list = []

order_product_ids = [[] for i in range(len(students) + len(course_participants) + len(webinar_participants))]


# orders for studies:
i = 0
for student in students:
    product_id = class_to_product[student['classID']]
    class_time = product_time_start_end[product_id]
    order = {
        'participantID': student['studentID'],
        'paymentLink': fake.link(),
        'orderDate': class_time[0] - timedelta(days=-random.randint(180, 360)),
    }   
    order_product_ids[i].append(product_id)
    i += 1
    orders_list.append(order)

# orders for courses:
for course_participant in course_participants:
    product_id = course_to_product[course_participant['courseID']]
    course_time = product_time_start_end[product_id]
    order = {
        'participantID': course_participant['studentID'],
        'paymentLink': fake.link(),
        'orderDate': course_time[0] + timedelta(days=-random.randint(1, 180)),
    }
    order_product_ids[i].append(product_id)
    i += 1
    orders_list.append(order)

# orders for webinars:
for webinar_participant in webinar_participants:
    product_id = wenbinar_to_product[webinar_participant['webinarID']]
    webinar_time = product_time_start_end[product_id]
    order = {
        'participantID': webinar_participant['participantID'],
        'paymentLink': fake.link(),
        'orderDate': webinar_time[0] + timedelta(days=-random.randint(1, 180)),
    }
    order_product_ids[i].append(product_id)
    i += 1
    orders_list.append(order)
orders_df = pd.DataFrame(orders_list)
orders_df.to_csv('data/orders.csv', index=False)


# generate orderDetails data
orderDetails_list = []
i = 0
for order in orders_list:
    order_date = order['orderDate']
    product = product_list[order_product_ids[i][0]]
    isCourse = (product['typeID']==1)
    order_detail = {
        'orderID': i,
        'productID': order_product_ids[i][0],
        'fullPaymentDate': order_date + timedelta(days=random.randint(1, 180)),
        'advancePaymentDate': (order_date + timedelta(days=random.randint(1, 3)) if isCourse else None),
        'statusID': random.randint(1, 4),
        'price': product_price[order_product_ids[i][0]]
    }
    i += 1
    orderDetails_list.append(order_detail)
orderDetails_df = pd.DataFrame(orderDetails_list)
orderDetails_df.to_csv('data/orderDetails.csv', index=False)


# generate orderStatus data
orderStatus = ["in progress", "completed", "cancelled", "refunded"]
orderStatus_df = pd.DataFrame(orderStatus, columns=['statusID'])
orderStatus_df.to_csv('data/orderStatus.csv', index=False)

# generate PaymentDeferral data
paymentDeferral = []
for i in range (1, 10):
    order_id = fake.random_int(min=1, max=len(orders_list))
    payment = {
        "orderID": fake.random_int(min=1, max=len(orders_list)),
        "newDueDate": orders_list[order_id]['orderDate'] + timedelta(days=random.randint(1, 30))
    }
    paymentDeferral.append(payment)
paymentDeferral_df = pd.DataFrame(paymentDeferral)
paymentDeferral_df.to_csv('data/paymentDeferral.csv', index=False)
# generate random company data
company_list = []

for i in range(company_ammount):
    company = {
        "companyName": fake.company(),
        "address": fake.address(),
        "email": fake.email(),
        "phone": fake.phone()
    }
    company_list.append(company)

company_df=pd.DataFrame(company_list)
company_df.to_csv('data/company.csv',index=False)


# generate meetingMode

modeNames = ["online synchronous", "online asynchronous", "stationary"]
meetingModes_df = pd.DataFrame(modeNames, columns=['modeName'])
meetingModes_df.to_csv('data/meetingMode.csv', index=False)


#generate random meeting data

meeting_list = []

for i in range(meeting_amount):
    subject_id = fake.random_int(min=1, max=subjects_length)
    instructors_id = [instructors_df['instructorID'].tolist() for _ in instructors]
    instructor_id = random.choice(instructors_id[0])
    translators_id = [translators_df['translator_id'].tolist() for _ in translators]
    translator_id = random.choice(translators_id[0])
    languages_for_translator = language_details_df.query('translatorID == @translator_id')['languageID'].tolist()
    language_id = random.choice(languages_for_translator)
    meeting = {
        "subjectID" : subject_id,
        "instructorID" : instructor_id,
        "translatorID" : translator_id,
        "languageID" : language_id,
        "meetingMode" : random.randint(0,3)
    }
    meeting_list.append(meeting)

meetings_df=pd.DataFrame(meeting_list)
meetings_df.to_csv('data/meetings.csv',index=False)


# generate random onlineAsyncMeeting data


onlineAsyncMeeting = []

for i in range(1,onlineAsyncMeeting_amount+1):
    o_a_meeting = {
        "meetingID": i,
        "recordingLink": fake.link()
    }
    onlineAsyncMeeting.append(o_a_meeting)

onlineAsyncMeeting_df = pd.DataFrame(onlineAsyncMeeting)
onlineAsyncMeeting_df.to_csv('data/onlineAsyncMeeting.csv', index=False)


# generate onlineSyncMeeting data

onlineSyncMeeting = []

for i in range(1, onlineSyncMeeting_amount + 1):
    o_s_meeting = {
        "meetingID": onlineAsyncMeeting_amount + i,
        "data": fake.date_between(start_date='-6y', end_date='+1y').strftime('%Y-%m-%d'),
        "meetingLink": fake.link(),
        "recordingLink": fake.link()
    }
    onlineSyncMeeting.append(o_s_meeting)

onlineSyncMeeting_df = pd.DataFrame(onlineSyncMeeting)
onlineSyncMeeting_df.to_csv('data/onlineSyncMeeting.csv', index=False)


#generate random stationaryMeetings data

stationaryMeetings = []

for i in range(1, stationary_meetings_amount + 1):
    o_s_meeting = {
        "meetingID": onlineAsyncMeeting_amount + onlineSyncMeeting_amount + i,
        "roomID": random.randint(1, 100),
        "date": fake.date_between(start_date='-6y', end_date='+1y').strftime('%Y-%m-%d')
    }
    stationaryMeetings.append(o_s_meeting)
stationaryMeetings_df = pd.DataFrame(stationaryMeetings)
stationaryMeetings_df.to_csv('data/stationaryMeetings.csv', index=False)


#generate random meetingTime data

meetingTimes = []
for i in range(meeting_amount):
    hour_start = random.randint(8, 17)
    start_minutes_tmp = str(15 * (random.randint(0, 3)))
    start_minutes = f"{start_minutes_tmp:02}"
    end_hours = hour_start + random.randint(1, 3)
    meeting_time = {
        "meetingID": i,
        "startTime": str(hour_start) + ":" + start_minutes,
        "endTime": str(end_hours) + ":" + start_minutes
    }
    meetingTimes.append(meeting_time)

meetingTimes_df = pd.DataFrame(meetingTimes)
meetingTimes_df.to_csv('data/meetingTimes.csv', index=False)

#generate roomDetails data

roomDetails = []
for i in range(1, 1000):
    hour_start = random.randint(8, 17)
    start_minutes_tmp = str(15 * (random.randint(0, 3)))
    start_minutes = f"{start_minutes_tmp:02}"
    end_hours = hour_start + random.randint(1, 3)
    instructors_id = [instructors_df['instructorID'].tolist() for instructor in instructors]
    instructor_id = random.choice(instructors_id[0])

    room_detail = {
        "roomID": random.randint(1, 100),
        "startTime": str(hour_start) + ":" + start_minutes,
        "endTime": str(end_hours) + ":" + start_minutes,
        "usedBy": instructor_id
    }
    roomDetails.append(room_detail)

roomDetails_df=pd.DataFrame(roomDetails)
roomDetails_df.to_csv('data/roomDetails.csv',index=False)

#generate random internships

internships = []

for i in range(internship_amount):
    supervisors_id = [internship_supervisors['internshipSupervisorID'].tolist() for supervisor in
                      internship_supervisors]
    supervisor_id = random.choice(supervisors_id[0])

    internship = {
        "companyID": random.randint(1, company_ammount + 1),
        "startDate": fake.date_between(start_date='-6y', end_date='+1y').strftime('%Y-%m-%d'),
        "supervisorID": supervisor_id
    }
    internships.append(internship)

internships_df=pd.DataFrame(internships)
internships_df.to_csv('data/internships.csv',index=False)

# generate moduleTypes

typeNames = ["online synchronous", "online asynchronous", "stationary", "hybrid"]
moduleTypes_df = pd.DataFrame(typeNames, columns=['modeName'])
moduleTypes_df.to_csv('data/moduleTypes.csv', index=False)

#generate random modules

modules = []

for i in range(module_amount):
    module = {
        "courseID": random.randint(0, len(course_df)-1),
        "description": fake.text(),
        "moduleTypeID": random.randint(0, 3)
    }
    modules.append(module)

modules_df = pd.DataFrame(modules)
modules_df.to_csv('data/modules.csv', index=False)

# generate conventionType

typeNames = ["online synchronous", "online asynchronous", "stationary", "hybrid"]
conventionTypes_df = pd.DataFrame(typeNames, columns=['modeName'])
conventionTypes_df.to_csv('data/conventionTypes.csv', index=False)

# generate convention
# nie zapomnieć dodać do products
conventions_per_study = 10
studies_amount = len(class_df)

conventions = []

for i in range(studies_amount):
    for j in range(conventions_per_study):
        price_for_students = (fake.random_int(min=100000, max=1000000) / 100)
        convent = {
            "classID": i,
            "productID": product_ammount + i * conventions_per_study + j,
            "limit": class_df['limit'][i] + fake.random_int(min=0, max=20), ## limity takie żeby pasować do limitów studiów tj są większe
            "price": round(price_for_students * 1.1, 2),
            "priceForStudents": price_for_students,
            "conventionTypeID": random.randint(0, 3),
        }
        conventions.append(convent)

conventions_df = pd.DataFrame(conventions)
conventions_df.to_csv('data/convention.csv', index=False)

# generating conventionDetails -- dodawanie studentów jako uczestników zjazdu, można dodać jeszcze jakieś losowe osoby
# PaymentDate chyba niepotrzebne bo jest w order i orderDetails

convention_participants = []
for i in range(len(students_df)):
    classID = students_df['classID'][i]
    studentID = students_df['studentID'][i]
    for j in range (conventions_per_study):
        convention_student = {
            "studentID":studentID,
            "conventionID":classID * conventions_per_study + j,
            "paymentDate":fake.date_time_between(start_date='-7y', end_date='now')
        }
        convention_participants.append(convention_student)    
convention_participants_df = pd.DataFrame(convention_participants)
convention_participants_df.to_csv('data/conventionDetails.csv', index=False)

# generate internshipDetails
# czy internship nie powinno być związane z class ?
# w internship jest datetime a w internshipDetails date

internship_details = []
internships_per_student = 2
for i in range(len(students_df)):
    studentID = students_df['studentID'][i]
    internshipID = fake.random_int(min=0, max=internship_amount-1) # albo losujemy internshipID albo dajemy takie samo jak classID 
    #internshipID = students_df['classID'][i]                      # ale tylko wtedy kiedy jest tyle samo wierszy w class co w internship
    for j in range (internships_per_student):
        internshipStartDate = datetime.strptime(internships_df['startDate'][internshipID],'%Y-%m-%d').date()
        thisdate = fake.date_between(start_date=internshipStartDate, end_date=internshipStartDate + timedelta(days=14))
        if(thisdate < datetime.today().date()):
            wasPresent = random.choices([0, 1], weights=[10, 90], k=1)[0]
        else:
            wasPresent = None
            
        internshipDetail = {
            "internshipID": internshipID,
            "studentID": studentID,
            "date": thisdate.strftime('%Y-%m-%d'), 
            "wasPresent": wasPresent,
        }
        internship_details.append(internshipDetail)    
internship_details_df = pd.DataFrame(internship_details)
internship_details_df.to_csv('data/internshipDetails.csv', index=False)

# przydzielenie losowo meetingów do kursów i klas
# nie jest zgodne z sylabusem
# część zjazdów i modułów nie będzie miała żadnego spotkania

moduleSchedule = []
studySchedule = []
i = 0
while(i < meeting_amount):
    meetingMode = meetings_df['meetingMode'][i] # OnSyn, OnAsyn, Stat
    if(random.choices([True, False], k=1)[0]):
        #studia
        conventionID = random.randint(0, len(conventions_df)-1)
        conventionMode = conventions_df['conventionTypeID'][conventionID] # OnSyn, OnAsyn, Stat, Hyb
        if(conventionMode == 3 or conventionMode == meetingMode):
            convention_meeting = {
                "meetingID": i,
                "conventionID": conventionID
            }
            studySchedule.append(convention_meeting)
            i=i+1
    else:
        #kurs
        moduleID = random.randint(0, len(modules_df)-1)
        moduleMode = modules_df['moduleTypeID'][moduleID]
        if(moduleMode == 3 or moduleMode == meetingMode):
            module_meeting = {
                "meetingID": i,
                "moduleID": moduleID
            }
            moduleSchedule.append(module_meeting)
            i=i+1
    
module_schedule_df = pd.DataFrame(moduleSchedule)
module_schedule_df.to_csv('data/moduleSchedule.csv', index=False)
study_schedule_df = pd.DataFrame(studySchedule)
study_schedule_df.to_csv('data/studySchedule.csv', index=False)

#generate meetingParticipants and asyncMeetingDetails



