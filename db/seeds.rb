# frozen_string_literal: true

issue_categories = ['Соціальний захист', #0
                    'Інші питання', #1
                    'Фінансові питання', #2
                    'Звернення до депутатів міської ради', #3
                    'Освіта', #4
                    'Забезпечення законності та правопорядку', #5
                    'Торгівля',#6
                    'Земельні питання',#7
                    'Архітектура та містобудування', #8
                    'Житлові питання',#9
                    'Капітальне будівництво', #10
                    'Культура', #11
                    'Служба оперативного реагування 15-80', #12
                    'Паркування', #13
                    'Реклама', #14
                    'Спорт', #15
                    'Охорона здоровля', #16
                    'Благоустрій міста', #17
                    'Утримання будинків, тарифи', #18
                    'Транспор і звязок', #19
                    'Комунальне господарство'] #20

categories = issue_categories.collect do |c|
    Category.create(name: c)
end

issues = [
    { title: 'Відсутній тротуар у проході між будинками',
      address: { lat: 48.9225648, lng: 24.710126,
                 street_address: 'вул. Грушевського 23' },
      category: categories[20],
      description: 'У проході у внутрішній двір між будинками №23 та №25 '\
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
  { name: 'Незаконний зал гральних автоматів',
    address: { lat: 48.92295044, lng: 24.7149092,
               street_address: 'вул. Михайла Грушевського 4' },
    category: categories[5],
    description: 'В приміщені "В мережі" працює незаконний зал '\
                 'компютерних ігрових автоматів.',
    issue_attachments_attributes: {
    attachment: Rack::Test::UploadedFile.new(
                  Rails.root.join('spec', 'files', 'i5.jpg')
                )
   },
  },
  { name: 'Зламане дерево нависає над пішохідною зоною',
    address: { lat: 48.92770049, lng: 24.71073926,
               street_address: 'вул. Військових Ветеранів 2' },
    category: categories[17],
    description: 'Зламане дерево нависає над пішохідною зоною '\
                 'в парку воїнів визволителів',

   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'tree.jpg')
                 )
   },
  },
  { name: 'Дорога після прокладання каналізації',
    address: { lat: 48.92773574, lng: 24.72647309,
               street_address: 'вул. Ясна 3' },
    category: categories[19],
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
  { name: 'На зупинці відсутній сміттєвий бак',
    address: { lat: 48.90853656, lng: 24.71631646,
               street_address: 'вул. Київська 75' },
    category: categories[17],
    description: 'На зупинці АТР відсутній сміттєвий бак. '\
                 'Вся зупинка у смітті!',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'garbage.jpg')
                 )
   },
 },
  { name: 'Самовільне встановлення лежачих поліцейських',
    address: { lat: 48.93360365, lng: 24.72393036,
               street_address: 'вул. Некрасова 5' },
    category: categories[19],
    description: 'Прошу зясувати законність і вжити заходів, '\
                 'щодо самовільно встановлених елементів примусового зниження '\
                 'швидкості, так званих \'лежачих поліцейських\', на ділянці дороги '\
                 'по вулиці Некрасова, буд 5. '\
                 'Очікую на вирішення даної проблеми!',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'obstacle.jpg')
                   )
     },
   },
  { name: 'Парковка',
    address: { lat: 48.92212798, lng: 24.7143817,
               street_address: 'вул. Козляника 22' },
    category: categories[13],
    description: 'Адреса: Козляника, 22 (поблизу будівлі державної адміністрації) '\
                 'Орієнтовна кількість місць – 13',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'parking.jpg')
                   )
     },
   },
  { name: 'Дитячий майданчик',
    address: { lat: 48.93557356, lng: 24.74924505,
               street_address: 'вул. Івана Миколайчука 8' },
    category: categories[17],
    description: 'Дитячий майданчик в жахливому стані. '\
                 'Необхідний ремонт!',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'playground.jpg')
                 )
   },
 },
  { name: 'Стихійна торгівля в центральній частині міста!',
    address: { lat: 48.91939965, lng: 24.70837891,
               street_address: 'вул. Січових Стрільців 13а' },
    category: categories[3],
    description: 'Прошу вжити відповідних заходів щодо ліквідації(!) '\
                 'стихійної вуличної торгівлі біля головного поштамту, '\
                 'по вул. Січових Стрільців',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'bargain.jpg')
                 )
   },
  },
  { name: 'Закинута будівля де живуть бомжі та наркомани',
    address: { lat: 48.91182018, lng: 24.73109722,
               street_address: 'вул. Хриплинська 11' },
    category: categories[8],
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
  { name: 'Вкрадений люк',
    address: { lat: 48.93679165, lng: 24.7450161,
               street_address: 'вул. Василя Стуса 15' },
    category: categories[5],
    description: 'Біля буд. 15 по вул. Василя Стуса, '\
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
  { name: 'Пішохідний перехід',
    address: { lat: 48.91996601, lng: 24.73392248,
               street_address: 'вул. Йосипа Сліпого 38' },
    category: categories[17],
    description: "Перехід не пристосований для візків
                  та людей з обмеженими можливостями.",
    issue_attachments_attributes: {
      attachment: Rack::Test::UploadedFile.new(
                  Rails.root.join('spec', 'files', 'crossing.jpg')
                  )
    },
  },
  { name: 'МАФи і самовільні споруди',
    address: { lat: 48.92295044, lng: 24.7149092,
               street_address: 'вул. Стефаника 35' },
    category: categories[8],
    description: 'Просимо Вас, звернути увагу на малі '\
                 'архітектурні форми (гаражі та інші споруди-самозахвати), '\
                 'які знаходяться під вікнами будинків 13 та 13а по вулиці Стефаника. '\
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
  { name: 'Не вивозиться сортоване сміття',
    address: { lat: 48.92770049, lng: 24.71073926,
               street_address: 'вул. Коперника 16' },
    category: categories[20],
    description: 'Більше місяця на вивозиться контейнер '\
                 'із сортованим сміттям (для пластику і паперу).',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'container.jpg')
                 )
   },
  },
  { name: 'Безпритульні собаки нападають на дітей',
    address: { lat: 48.92773574, lng: 24.72647309,
               street_address: 'вул. Патона 20а' },
    category: categories[16],
    description: 'Неймовірна кількість собак які мешкають в нашому районі '\
                 'створюють страшну загрозу для життя і здоровля '\
                 'людей та особливо дітей. Приблизно кількість собак 10 - 15 особин. '\
                 'Собаки кидаються на дітей на дитячому майданчику, '\
                 'особливо на дітей що катаються на велосипед. Тільки завдяки небайдужим '\
                 'жителям 19.08.2016р. вдалося врятувати 7-р. хлопчика від оскаженілої '\
                 'зграї собак. Аналогічні ситуації трапляються кожен день.',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'doges.jpg')
                   )
     },
  },
  { name: 'Занедбані тротуари',
		address: { lat: 48.92773574, lng: 24.72647309,
							 street_address: 'вул. Бугая 8' },
		category: categories[20],
		description: 'Прохання навести лад з тротуарами (по обидва боки) '\
		             'по вулиці Бугая.',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'sidewalk.jpg')
                   )
     },
  },
	{ name: 'Гральний заклад',
		address: { lat: 48.94352173, lng: 24.74672198,
							 street_address: 'вул. Потічна 5а' },
		category: categories[5],
		description: 'У центрі Каскаду працюють два гральні заклади. '\
								 'Чим займається поліція і чому їх не бачить??',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'casino.jpg')
                   )
     },
  },
	{ name: 'Завалений прохід до тех. приміщення',
		address: { lat: 48.92388568, lng: 24.69689727,
							 street_address: 'вул. Вишневецького 9' },
		category: categories[20],
		description: 'Власниками квартири за адресою, Вишневецького 9 кв.2, '\
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
	{ name: 'Похилена електроопора',
		address: { lat: 48.92388568, lng: 24.69689727,
							 street_address: 'вул. Богдана Лепкого 41' },
		category: categories[19],
		description: 'Похилена опора, яка тримає тролейбусні розтяжки. '\
								 'Є ризик обриву електролінії! Прохання усунути несправність.',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'troley.jpg')
                   )
     },
  },
	{ name: 'Законність встановлення вуличного пандусу',
		address: { lat: 48.92388568, lng: 24.69689727,
							 street_address: 'вул. Василя Стуса 17' },
		category: categories[5],
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
  { name: 'Покинутий Автомобіль',
    address: { lat: 48.92388568, lng: 24.69689727,
               street_address: 'вул. Олександра Довженка 27г' },
    category: categories[18],
    description: 'У дворі будинку по вул. Олександра Довженка 27г, де і так не вистачає '\
                 'парко місць вже багато років стоїть старий несправний бус Мерседес '\
                 'коричневого кольору номерний знак 068-10 МО в середині автобус вщент '\
                 'заповнений сміттям. Прохання допомогти у вирішенні проблеми!',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'abandoned.jpg')
                   )
     },
  },
  { name: "Забруднений паркан біля пам'ятки архітектури",
    address: { lat: 48.92388568, lng: 24.69689727,
               street_address: 'вул. Тараса Шевченка 98' },
    category: categories[17],
    description: 'На вул. Шевченка, біля пам\'ятки архітектури, яка входить у '\
                 'спадщину ЮНЕСКО знаходиться в жахливому стані паркан - забруднений та '\
                 'заклеєний рекламою. Прохання очистити його та привести до естетичного вигляду.',
     issue_attachments_attributes: {
       attachment: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec', 'files', 'dirty_1.jpg')
                   )
     },
  },
  { name: "Зруйнована сміттєва урна",
    address: { lat: 48.92388568, lng: 24.69689727,
               street_address: 'вул. Тараса Шевченка 98' },
    category: categories[17],
    description: 'На вул. Шевченка, біля пам\'ятки архітектури, яка входить у спадщину ЮНЕСКО, '\
                 'знаходиться сміттєва урна у жахливому стані. Прохання термінового замінити її.',
   issue_attachments_attributes: {
     attachment: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec', 'files', 'destroy.jpg')
                 )
   },
  },
  { name: "Надання форми ялинкам",
    address: { lat: 48.9211466, lng: 24.7108564,
               street_address: 'пл. Адама Міцькевича' },
    category: categories[17],
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
                   Rails.root.join('spec', 'files', 'dirty_2.jpg')
                   )
     },
  },
  { name: "Забруднені ворота",
    address: { lat: 48.9211466, lng: 24.7108564,
               street_address: 'вул. Гетьмана Мазепи 30' },
    category: categories[20],
    description: 'На вул. Гетьмана Мазепи, 30, знаходяться занедбані ворота, '\
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
  FactoryGirl.create(:issue, title: issue[:title],
                             location: issue[:address][:street_address],
                             latitude: issue[:address][:lat],
                             longitude: issue[:address][:lng],
                             address: issue[:address][:street_address],
                             name: Faker::Name.name_with_middle,
                             phone: Faker::PhoneNumber.cell_phone,
                             category_id: categories.index(issue[:category]),
                             description: issue[:description],
                             status: :pending, 
                             created_at: Time.now - rand(10).days)
                             .issue_attachments.create!([
                              {
                                attachment: issue[:issue_attachments_attributes][:attachment]
                              }
                              ]
                             )
end

Issue.all.each do |issue|
  20.times do
    FactoryGirl.create(:comment,
                       user_id: rand(1..User.count),
                       commentable: issue,
                       created_at: Time.now - rand(10).days)
  end
end
