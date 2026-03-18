import '../models/habit.dart';

List<Habit> getDefaultHabits() => [
  Habit(id: 'habit_1',  name: "Wake Up",                  time: "5:30 AM",      emoji: "🌅"),
  Habit(id: 'habit_2',  name: "Drink Warm Water",          time: "6:00 AM",      emoji: "💧"),
  Habit(id: 'habit_3',  name: "Morning Walk / Yoga",       time: "6:30 AM",      emoji: "🧘"),
  Habit(id: 'habit_4',  name: "Breakfast (Idli / Dosa)",   time: "8:30 AM",      emoji: "🍽️"),
  Habit(id: 'habit_5',  name: "Fruit (Banana / Papaya)",   time: "11:00 AM",     emoji: "🍌"),
  Habit(id: 'habit_6',  name: "Hydration",                 time: "Every 1 hr",   emoji: "🥤"),
  Habit(id: 'habit_7',  name: "Lunch (Rice + Sambar)",     time: "1:30 PM",      emoji: "🍛"),
  Habit(id: 'habit_8',  name: "Evening Snack",             time: "5:00 PM",      emoji: "🥜"),
  Habit(id: 'habit_9',  name: "Dinner",                    time: "8:00 PM",      emoji: "🌙"),
  Habit(id: 'habit_10', name: "No Screen",                 time: "10:00 PM",     emoji: "📵"),
];

