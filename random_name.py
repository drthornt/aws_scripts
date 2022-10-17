#!/usr/bin/env python3
import random

colours = []

fruits = [
  "apple",
  "apricot",
  "avocado",
  "banana",
  "blackberry",
  "blackcurrant",
  "blueberry",
  "breadfruit",
  "cactus",
  "cantaloupe",
  "cashew",
  "cherry",
  "clementine",
  "coconut",
  "crabapple",
  "cranberry",
  "cucumber",
  "currant",
  "date",
  "dragonfruit",
  "durian",
  "eggplant",
  "elderberry",
  "fig",
  "goji",
  "gooseberry",
  "grape",
  "grapefruit",
  "guava",
  "honeyberry",
  "honeydew",
  "huckleberry",
  "jackfruit",
  "jostaberry",
  "juniper",
  "kaffir",
  "kiwi",
  "kumquat",
  "lemon",
  "lime",
  "loganberry",
  "longan",
  "loquat",
  "lychee",
  "mandarine",
  "mango",
  "melon",
  "mulberry",
  "nectarine",
  "olive",
  "orange",
  "papaya",
  "passionfruit",
  "pawpaw",
  "pea",
  "peach",
  "pear",
  "pepper",
  "persimmon",
  "pineapple",
  "pineberry",
  "plantain",
  "plum",
  "pomegranate",
  "pomelo",
  "prune",
  "pumpkin",
  "raisin",
  "rambutan",
  "raspberry",
  "redcurrant",
  "satsuma",
  "soursop",
  "squash",
  "starfruit",
  "strawberry",
  "tamarillo",
  "tamarind",
  "tangelo",
  "tangerine",
  "tomato",
  "watermelon",
  "yuzu",
  "zucchini"
]

adjectives = [
    "admiring",
    "adoring",
    "affectionate",
    "agitated",
    "amazing",
    "angry",
    "awesome",
    "beautiful",
    "blissful",
    "bold",
    "boring",
    "brave",
    "busy",
    "charming",
    "clever",
    "cool",
    "compassionate",
    "competent",
    "condescending",
    "confident",
    "cranky",
    "crazy",
    "dazzling",
    "determined",
    "distracted",
    "dreamy",
    "eager",
    "ecstatic",
    "elastic",
    "elated",
    "elegant",
    "eloquent",
    "epic",
    "exciting",
    "fervent",
    "festive",
    "flamboyant",
    "focused",
    "friendly",
    "frosty",
    "funny",
    "gallant",
    "gifted",
    "goofy",
    "gracious",
    "great",
    "happy",
    "hardcore",
    "heuristic",
    "hopeful",
    "hungry",
    "infallible",
    "inspiring",
    "intelligent",
    "interesting",
    "jolly",
    "jovial",
    "keen",
    "kind",
    "laughing",
    "loving",
    "lucid",
    "magical",
    "mystifying",
    "modest",
    "musing",
    "naughty",
    "nervous",
    "nice",
    "nifty",
    "nostalgic",
    "objective",
    "optimistic",
    "peaceful",
    "pedantic",
    "pensive",
    "practical",
    "priceless",
    "quirky",
    "quizzical",
    "recursing",
    "relaxed",
    "reverent",
    "romantic",
    "sad",
    "serene",
    "sharp",
    "silly",
    "sleepy",
    "stoic",
    "strange",
    "stupefied",
    "suspicious",
    "sweet",
    "tender",
    "thirsty",
    "trusting",
    "unruffled",
    "upbeat",
    "vibrant",
    "vigilant",
    "vigorous",
    "wizardly",
    "wonderful",
    "xenodochial",
    "youthful",
    "zealous",
    "zen"
]

adjective = random.choice(adjectives)
fruit = random.choice(fruits)

print("{}-{}".format(adjective,fruit))