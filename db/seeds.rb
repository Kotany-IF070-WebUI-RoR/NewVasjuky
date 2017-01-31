# frozen_string_literal: true

FactoryGirl.create(:user, :admin)

issue_categories = [
    { name: 'Соціальний захист',
      description: 'Питання щодо соціального захисту в м.Івано-Франківську',
      tags: '#ІваноФранківськ #СоціальнийЗахист'},
    { name: 'Інші питання',
      description: 'Всі запитання та проблеми, які не входять в інші категорії',
      tags: '#ІваноФранківськ #ПроблемиМіста'},
    { name: 'Фінансові питання',
      description: 'Запитання щодо фінансів міста',
      tags: '#ІваноФранківськ #ФінансовіПитання'},
    { name: 'Освіта',
      description: 'Запитання та проблеми щодо освітніх закладів Івано-Франківська',
      tags: '#ІваноФранківськ #Освіта'},
    { name: 'Забезпечення законності та правопорядку',
      description: 'Запитання та проблеми щодо законності, правопорядку, правоохоронних органів міста',
      tags: '#ІваноФранківськ #Законність #Правопорядок #Поліція'},
    { name: 'Торгівля',
      description: 'Проблеми та запитання щодо закладів торгівлі м.Івано-Франківська',
      tags: '#ІваноФранківськ #Торгівля'},
    { name: 'Земельні питання',
      description: 'Земельні питання міста',
      tags: '#ІваноФранківськ #ЗемельніПитання'},
    { name: 'Архітектура та містобудування',
      description: 'Питання щодо архітектури та містобудування Івано-Франківська',
      tags: '#ІваноФранківськ #Архітектура #Містобудування'},
    { name: 'Житлові питання',
      description: 'Житлові питання міста Івано-Франківська',
      tags: '#ІваноФранківськ #ЖитловіПитання'},
    { name: 'Культура',
      description: 'Питання щодо культурного життя міста',
      tags: '#ІваноФранківськ #Культура'},
    { name: 'Паркування',
      description: 'Запитання щодо паркування в Івано-Франківську',
      tags: '#ІваноФранківськ #Паркування'},
    { name: 'Реклама',
      description: 'Запитання щодо всіх видів реклами в Івано-Франківську',
      tags: '#ІваноФранківськ #Реклама'},
    { name: 'Спорт',
      description: 'Питання та проблеми любительского та профісійного спорту м.Івано-Франківська',
      tags: '#ІваноФранківськ #Спорт'},
    { name: 'Охорона здоровля',
      description: 'Запитання щодо охорони здоровля та закладів медицини',
      tags: '#ІваноФранківськ #ОхоронаЗдоровля #Медицина'},
    { name: 'Благоустрій міста',
      description: 'Проблеми благоустрою м.Івано-Франківська',
      tags: '#ІваноФранківськ #Благоустрій'},
    { name: 'Утримання будинків, тарифи',
      description: 'Запитання щодо утримання будинків та тарифів м.Івано-Франківська',
      tags: '#ІваноФранківськ #Тарифи #УтриманняБудинків'},
    { name: 'Транспорт і звязок',
      description: 'Питання та проблеми транспорту і звязку м.Івано-Франківська',
      tags: '#ІваноФранківськ #Транспорт #Звязок'},
    { name: 'Комунальне господарство',
      description: 'Проблеми  комунального господарства м.Івано-Франківська',
      tags: '#ІваноФранківськ #КомунальнеГосподарство'}
]

issue_categories.collect do |c|
  Category.create(name: c[:name],
                  description: c[:description],
                  tags: c[:tags])
end

issues = [
  { title: 'Відсутній тротуар у проході між будинками',
    address: { lat: 49.9225649, lng: 25.710127,
               street_address: 'вул. Грушевського 24' },
    category_id: 17,
    description: 'У проході у внутрішній двір між будинками №24 та №26 '\
               'на проспекті Грушевського після ремонту відсутнє покриття. '\
               'Існує реальна загроза травмуватися для жильців та відвідувачів. '\
               'Прохання виправити ситуацію. '\
               'Обидва будинки в комунальній власності.',
  issue_attachments_attributes: {
    attachment: Rack::Test::UploadedFile.new(
                Rails.root.join('spec', 'files', 'i4.jpg')
                )
  },
},
{ title: 'Незаконний зал гральних автоматів',
  address: { lat: 49.92295045, lng: 25.7149093,
             street_address: 'вул. Михайла Грушевського 5' },
  category_id: 6,
  description: 'В приміщені "В мережі" працює незаконний зал '\
               'компютерних ігрових автоматів.',
  issue_attachments_attributes: {
  attachment: Rack::Test::UploadedFile.new(
                Rails.root.join('spec', 'files', 'i5.jpg')
              )
 },
},
{ title: 'Зламане дерево нависає над пішохідною зоною',
  address: { lat: 49.92770050, lng: 25.71073927,
             street_address: 'вул. Військових Ветеранів 3' },
  category_id: 16,
  description: 'Зламане дерево нависає над пішохідною зоною '\
               'в парку воїнів визволителів',

 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'tree.jpg')
               )
 },
},
{ title: 'Дорога після прокладання каналізації',
  address: { lat: 49.92773575, lng: 25.72647310,
             street_address: 'вул. Ясна 4' },
  category_id: 17,
  description: 'В жахливому стані залишилась дорога на вулиці Ясна '\
               'після прокладання водопроводу та каналізації. '\
               'Хоча перед початком робіт '\
               'виконавці обіцяли привести дорогу до ладу, '\
               'вирівняти та підсипати гравієм. '\
               'Наразі вийти без гумових чобіт на вулицю неможливо.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'road.jpg')
                 )
   },
 },
{ title: 'На зупинці відсутній сміттєвий бак',
  address: { lat: 49.90853657, lng: 25.71631647,
             street_address: 'вул. Київська 76' },
  category_id: 16,
  description: 'На зупинці АТР відсутній сміттєвий бак. '\
               'Вся зупинка у смітті!',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'garbage.jpg')
               )
 },
},
{ title: 'Самовільне встановлення лежачих поліцейських',
  address: { lat: 49.93360366, lng: 25.72393037,
             street_address: 'вул. Некрасова 6' },
  category_id: 17,
  description: 'Прошу зясувати законність і вжити заходів, '\
               'щодо самовільно встановлених елементів примусового зниження '\
               'швидкості, так званих \'лежачих поліцейських\', на ділянці дороги '\
               'по вулиці Некрасова, буд 6. '\
               'Очікую на вирішення даної проблеми!',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'obstacle.jpg')
                 )
   },
 },
{ title: 'Парковка',
  address: { lat: 49.92212799, lng: 25.7143818,
             street_address: 'вул. Козляника 23' },
  category_id: 10,
  description: 'Адреса: Козляника, 23 (поблизу будівлі державної адміністрації) '\
               'Орієнтовна кількість місць – 14',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'parking.jpg')
                 )
   },
 },
{ title: 'Дитячий майданчик',
  address: { lat: 49.93557357, lng: 25.74924506,
             street_address: 'вул. Івана Миколайчука 9' },
  category_id: 1,
  description: 'Дитячий майданчик в жахливому стані. '\
               'Необхідний ремонт!',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'playground.jpg')
               )
 },
},
{ title: 'Стихійна торгівля в центральній частині міста!',
  address: { lat: 49.91939966, lng: 25.70837892,
             street_address: 'вул. Січових Стрільців 14а' },
  category_id: 4,
  description: 'Прошу вжити відповідних заходів щодо ліквідації(!) '\
               'стихійної вуличної торгівлі біля головного поштамту, '\
               'по вул. Січових Стрільців',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'bargain.jpg')
               )
 },
},
{ title: 'Закинута будівля де живуть бомжі та наркомани',
  address: { lat: 49.91182019, lng: 25.73109723,
             street_address: 'вул. Хриплинська 12' },
  category_id: 9,
  description: 'В даному будинку живуть бомжі та наркомани '\
               'та ходить бо ніяого не огороджено. '\
               'Коли це неподобство прикриють? '\
               'Продайте комсь хай наведе порядок.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'bomm.jpg')
                 )
   },
},
{ title: 'Вкрадений люк',
  address: { lat: 49.93679166, lng: 25.7450162,
             street_address: 'вул. Василя Стуса 16' },
  category_id: 6,
  description: 'Біля буд. 16 по вул. Василя Стуса, '\
               'зник нещодавно встановлений каналізаційний люк. '\
               'Прошу вжити якнайшвидших заходів та встановити '\
               'каналізаційний люк оскільки там кожного дня ходять перехожі '\
               'в т.ч. і діти. А також звернутися до правоохоронних органів '\
               'з приводу його пропажі. Фото додаю.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'hole.jpg')
                 )
   },
},
{ title: 'Пішохідний перехід',
  address: { lat: 49.91996602, lng: 25.73392249,
             street_address: 'вул. Йосипа Сліпого 39' },
  category_id: 17,
  description: "Перехід не пристосований для візків
                та людей з обмеженими можливостями.",
  issue_attachments_attributes: {
    attachment: Rack::Test::UploadedFile.new(
                Rails.root.join('spec', 'files', 'crossing.jpg')
                )
  },
},
{ title: 'МАФи і самовільні споруди',
  address: { lat: 49.92295045, lng: 25.7149093,
             street_address: 'вул. Стефаника 36' },
  category_id: 9,
  description: 'Просимо Вас, звернути увагу на малі '\
               'архітектурні форми (гаражі та інші споруди-самозахвати), '\
               'які знаходяться під вікнами будинків 14 та 14а по вулиці Стефаника. '\
               'Порушення громадського спокою та систематичне вживання алкогольних '\
               'напоїв у нічний час деяких власників споруд, не дають змоги'\
               'нормальній життєдіяльності мешканцям прилеглих будинків.'\
               'На прибудинкову територію завезені гаражі і їх кількість зростає. '\
               'За рахунок площі демонтованих споруд просимо привести в належний '\
               'стан територію зі сміттєвими контейнерами.',
  issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'MAF.jpg')
               )
  },
},
{ title: 'Не вивозиться сортоване сміття',
  address: { lat: 49.92770050, lng: 25.71073927,
             street_address: 'вул. Коперника 17' },
  category_id: 17,
  description: 'Більше місяця на вивозиться контейнер '\
               'із сортованим сміттям (для пластику і паперу).',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'container.jpg')
               )
 },
},
{ title: 'Безпритульні собаки нападають на дітей',
  address: { lat: 49.92773575, lng: 25.72647310,
             street_address: 'вул. Патона 21а' },
  category_id: 13,
  description: 'Неймовірна кількість собак які мешкають в нашому районі '\
               'створюють страшну загрозу для життя і здоровля '\
               'людей та особливо дітей. Приблизно кількість собак 11 - 16 особин. '\
               'Собаки кидаються на дітей на дитячому майданчику, '\
               'особливо на дітей що катаються на велосипед. Тільки завдяки небайдужим '\
               'жителям 20.9.2017р. вдалося врятувати 8-р. хлопчика від оскаженілої '\
               'зграї собак. Аналогічні ситуації трапляються кожен день.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'doges.jpg')
                 )
   },
},
{ title: 'Занедбані тротуари',
  address: { lat: 49.92773575, lng: 25.72647310,
             street_address: 'вул. Бугая 9' },
  category_id: 16,
  description: 'Прохання навести лад з тротуарами (по обидва боки) '\
               'по вулиці Бугая.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'sidewalk.jpg')
                 )
   },
},
{ title: 'Гральний заклад',
  address: { lat: 49.94352174, lng: 25.74672199,
             street_address: 'вул. Потічна 6а' },
  category_id: 6,
  description: 'У центрі Каскаду працюють два гральні заклади. '\
               'Чим займається поліція і чому їх не бачить??',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'casino.jpg')
                 )
   },
},
{ title: 'Завалений прохід до тех. приміщення',
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Вишневецького 10' },
  category_id: 11,
  description: 'Власниками квартири за адресою, Вишневецького 10 кв.3, '\
               'завалено прохід будівельними матеріалами, до законного технічного '\
               'приміщення на цій ділянці, що унеможливлює доступ до нього. Також, '\
               'незаконно знято частину покрівлі даного приміщення, що призводить '\
               'до псування майна, яке знаходиться в середині.',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'exit.jpg')
               )
 },
},
{ title: 'Похилена електроопора',
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Богдана Лепкого 42' },
  category_id: 17,
  description: 'Похилена опора, яка тримає тролейбусні розтяжки. '\
               'Є ризик обриву електролінії! Прохання усунути несправність.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'troley.jpg')
                 )
   },
},
{ title: 'Законність встановлення вуличного пандусу',
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Василя Стуса 18' },
  category_id: 6,
  description: 'Прошу надати інформацію про законність та наявність дозволу щодо '\
               'встановлення вуличного пандусу біля магазину "Ательє керамічної плитки", '\
               'оскільки даний пандус займає більшу частину тротуару та погіршує '\
               'його використання.',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'pandus.jpg')
               )
 },
},
{ title: 'Покинутий Автомобіль',
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Олександра Довженка 28г' },
  category_id: 16,
  description: 'У дворі будинку по вул. Олександра Довженка 28г, де і так не вистачає '\
               'парко місць вже багато років стоїть старий несправний бус Мерседес '\
               'коричневого кольору номерний знак 69-9 МО в середині автобус вщент '\
               'заповнений сміттям. Прохання допомогти у вирішенні проблеми!',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'abandoned.jpg')
                 )
   },
},
{ title: "Забруднений паркан біля пам'ятки архітектури",
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Тараса Шевченка 99' },
  category_id: 17,
  description: 'На вул. Шевченка, біля пам\'ятки архітектури, яка входить у '\
               'спадщину ЮНЕСКО знаходиться в жахливому стані паркан - забруднений та '\
               'заклеєний рекламою. Прохання очистити його та привести до естетичного вигляду.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'dirty_1.jpg')
                 )
   },
},
{ title: "Зруйнована сміттєва урна",
  address: { lat: 49.92388569, lng: 25.69689728,
             street_address: 'вул. Тараса Шевченка 99' },
  category_id: 17,
  description: 'На вул. Шевченка, біля пам\'ятки архітектури, яка входить у спадщину ЮНЕСКО, '\
               'знаходиться сміттєва урна у жахливому стані. Прохання термінового замінити її.',
 issue_attachments_attributes: {
   attachment: Rack::Test::UploadedFile.new(
               Rails.root.join('spec', 'files', 'destroy.jpg')
               )
 },
},
{ title: "Надання форми ялинкам",
  address: { lat: 49.9211467, lng: 25.7108565,
             street_address: 'пл. Адама Міцькевича' },
  category_id: 1,
  description: 'На пл. Міцькевича красуються зимові красуні, які зростають досить дико. '\
               'Ялинкам не надається відповідна форма. Років десять тому тут вже росли ялинки '\
               'подібного розміру, і замість надання їм форми - їх було викорчувано і насаджено '\
               'нових, які тепер досягли такого ж росту. Прохання, не викорчовувати їх на цей раз, '\
               'а надати їм естетичної форми, щоб вони мали однаковий та симетричний вигляд. '\
               'І надалі слід слідкувати за їх зростанням. Також було б доречним вже до наступний '\
               'Різдвяних свях їх прикрасити святковою ілюмінацією, адже це одна з основних площ '\
               'яка засаджена ялинками - одним із символів Різдва.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'xmas_tree.jpg')
                 )
   },
},
{ title: "Забруднені ворота",
  address: { lat: 49.9211467, lng: 25.7108565,
             street_address: 'вул. Гетьмана Мазепи 31' },
  category_id: 16,
  description: 'На вул. Гетьмана Мазепи, 31, знаходяться занедбані ворота, '\
               'які псують вигляд вулиці. '\
               'Прохання очистити ворота. Дякую.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'dirty_2.jpg')
                 )
   },
}
]


issues.each do |issue|
FactoryGirl.create(:issue,
                    title: issue[:title],
                    location: issue[:address][:street_address],
                    latitude: issue[:address][:lat],
                    longitude: issue[:address][:lng],
                    address: issue[:address][:street_address],
                    name: Faker::Name.name_with_middle,
                    phone: Faker::PhoneNumber.cell_phone,
                    category_id: issue[:category_id],
                    description: issue[:description],
                    created_at: Time.now - rand(11).days,
                    status: :opened )
                    .issue_attachments.create!(
                    [
                      {
                       attachment:
                              issue[:issue_attachments_attributes][:attachment]
                      }
                    ])
end

Issue.all.each do |issue|
  21.times do
    FactoryGirl.create(:comment,
                       user_id: rand(2..User.count),
                       commentable: issue,
                       created_at: Time.now - rand(11).days)
  end
end
