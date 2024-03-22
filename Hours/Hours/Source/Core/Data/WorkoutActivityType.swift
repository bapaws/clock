//
//  WorkoutActivityType.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/22.
//

import HealthKit

let workoutActivityTypeJson =
    """
    [
        {
            "type": 1,
            "name": {
                "en": "American Football",
                "cn": "橄榄球"
            }
        },
        {
            "type": 2,
            "name": {
                "en": "Archery",
                "cn": "箭术"
            }
        },
        {
            "type": 3,
            "name": {
                "en": "Australian Football",
                "cn": "澳式足球"
            }
        },
        {
            "type": 4,
            "name": {
                "en": "Badminton",
                "cn": "羽毛球"
            }
        },
        {
            "type": 5,
            "name": {
                "en": "Baseball",
                "cn": "棒球"
            }
        },
        {
            "type": 6,
            "name": {
                "en": "Basketball",
                "cn": "篮球"
            }
        },
        {
            "type": 7,
            "name": {
                "en": "Bowling",
                "cn": "保龄球"
            }
        },
        {
            "type": 8,
            "name": {
                "en": "Boxing",
                "cn": "拳击"
            }
        },
        {
            "type": 9,
            "name": {
                "en": "Climbing",
                "cn": "攀岩"
            }
        },
        {
            "type": 10,
            "name": {
                "en": "Cricket",
                "cn": "板球"
            }
        },
        {
            "type": 11,
            "name": {
                "en": "Cross Training",
                "cn": "综合训练"
            }
        },
        {
            "type": 12,
            "name": {
                "en": "Curling",
                "cn": "冰壶"
            }
        },
        {
            "type": 13,
            "name": {
                "en": "Cycling",
                "cn": "自行车运动"
            }
        },
        {
            "type": 14,
            "name": {
                "en": "Dance",
                "cn": "舞蹈"
            }
        },
        {
            "type": 15,
            "name": {
                "en": "Dance Inspired Training",
                "cn": "舞蹈灵感训练"
            }
        },
        {
            "type": 16,
            "name": {
                "en": "Elliptical",
                "cn": "椭圆机"
            }
        },
        {
            "type": 17,
            "name": {
                "en": "Equestrian Sports",
                "cn": "马术运动"
            }
        },
        {
            "type": 18,
            "name": {
                "en": "Fencing",
                "cn": "击剑"
            }
        },
        {
            "type": 19,
            "name": {
                "en": "Fishing",
                "cn": "钓鱼"
            }
        },
        {
            "type": 20,
            "name": {
                "en": "Functional Strength Training",
                "cn": "功能性力量训练"
            }
        },
        {
            "type": 21,
            "name": {
                "en": "Golf",
                "cn": "高尔夫"
            }
        },
        {
            "type": 22,
            "name": {
                "en": "Gymnastics",
                "cn": "体操"
            }
        },
        {
            "type": 23,
            "name": {
                "en": "Handball",
                "cn": "手球"
            }
        },
        {
            "type": 24,
            "name": {
                "en": "Hiking",
                "cn": "徒步旅行"
            }
        },
        {
            "type": 25,
            "name": {
                "en": "Hockey",
                "cn": "曲棍球"
            }
        },
        {
            "type": 26,
            "name": {
                "en": "Hunting",
                "cn": "打猎"
            }
        },
        {
            "type": 27,
            "name": {
                "en": "Lacrosse",
                "cn": "长曲棍球"
            }
        },
        {
            "type": 28,
            "name": {
                "en": "Martial Arts",
                "cn": "武术"
            }
        },
        {
            "type": 29,
            "name": {
                "en": "Mind And Body",
                "cn": "身心训练"
            }
        },
        {
            "type": 31,
            "name": {
                "en": "Paddle Sports",
                "cn": "划船运动"
            }
        },
        {
            "type": 32,
            "name": {
                "en": "Play",
                "cn": "游戏"
            }
        },
        {
            "type": 33,
            "name": {
                "en": "Preparation And Recovery",
                "cn": "准备和恢复"
            }
        },
        {
            "type": 34,
            "name": {
                "en": "Racquetball",
                "cn": "短柄墙球"
            }
        },
        {
            "type": 35,
            "name": {
                "en": "Rowing",
                "cn": "划船"
            }
        },
        {
            "type": 36,
            "name": {
                "en": "Rugby",
                "cn": "橄榄球"
            }
        },
        {
            "type": 37,
            "name": {
                "en": "Running",
                "cn": "跑步"
            }
        },
        {
            "type": 38,
            "name": {
                "en": "Sailing",
                "cn": "帆船运动"
            }
        },
        {
            "type": 39,
            "name": {
                "en": "Skating Sports",
                "cn": "滑冰/滑板"
            }
        },
        {
            "type": 40,
            "name": {
                "en": "Snow Sports",
                "cn": "冰雪运动"
            }
        },
        {
            "type": 41,
            "name": {
                "en": "Soccer",
                "cn": "足球"
            }
        },
        {
            "type": 42,
            "name": {
                "en": "Softball",
                "cn": "垒球"
            }
        },
        {
            "type": 43,
            "name": {
                "en": "Squash",
                "cn": "壁球"
            }
        },
        {
            "type": 44,
            "name": {
                "en": "Stair Climbing",
                "cn": "攀楼梯"
            }
        },
        {
            "type": 45,
            "name": {
                "en": "Surfing Sports",
                "cn": "冲浪"
            }
        },
        {
            "type": 46,
            "name": {
                "en": "Swimming",
                "cn": "游泳"
            }
        },
        {
            "type": 47,
            "name": {
                "en": "Table Tennis",
                "cn": "乒乓球"
            }
        },
        {
            "type": 48,
            "name": {
                "en": "Tennis",
                "cn": "网球"
            }
        },
        {
            "type": 49,
            "name": {
                "en": "Track And Field",
                "cn": "田径"
            }
        },
        {
            "type": 50,
            "name": {
                "en": "Traditional Strength Training",
                "cn": "传统力量训练"
            }
        },
        {
            "type": 51,
            "name": {
                "en": "Volleyball",
                "cn": "排球"
            }
        },
        {
            "type": 52,
            "name": {
                "en": "Walking",
                "cn": "步行"
            }
        },
        {
            "type": 53,
            "name": {
                "en": "Water Fitness",
                "cn": "水中健身"
            }
        },
        {
            "type": 54,
            "name": {
                "en": "Water Polo",
                "cn": "水球"
            }
        },
        {
            "type": 55,
            "name": {
                "en": "Water Sports",
                "cn": "水上运动"
            }
        },
        {
            "type": 56,
            "name": {
                "en": "Wrestling",
                "cn": "摔跤"
            }
        },
        {
            "type": 57,
            "name": {
                "en": "Yoga",
                "cn": "瑜伽"
            }
        },
        {
            "type": 58,
            "name": {
                "en": "Barre",
                "cn": "杆操"
            }
        },
        {
            "type": 59,
            "name": {
                "en": "Core Training",
                "cn": "核心训练"
            }
        },
        {
            "type": 60,
            "name": {
                "en": "Cross Country Skiing",
                "cn": "越野滑雪"
            }
        },
        {
            "type": 61,
            "name": {
                "en": "Downhill Skiing",
                "cn": "高山滑雪"
            }
        },
        {
            "type": 62,
            "name": {
                "en": "Flexibility",
                "cn": "灵活性"
            }
        },
        {
            "type": 63,
            "name": {
                "en": "High Intensity Interval Training",
                "cn": "高强度间歇训练"
            }
        },
        {
            "type": 64,
            "name": {
                "en": "Jump Rope",
                "cn": "跳绳"
            }
        },
        {
            "type": 65,
            "name": {
                "en": "Kickboxing",
                "cn": "散打"
            }
        },
        {
            "type": 66,
            "name": {
                "en": "Pilates",
                "cn": "普拉提"
            }
        },
        {
            "type": 67,
            "name": {
                "en": "Snowboarding",
                "cn": "单板滑雪"
            }
        },
        {
            "type": 68,
            "name": {
                "en": "Stairs",
                "cn": "楼梯"
            }
        },
        {
            "type": 69,
            "name": {
                "en": "Step Training",
                "cn": "台阶训练"
            }
        },
        {
            "type": 70,
            "name": {
                "en": "Wheelchair Walk Pace",
                "cn": "轮椅步行速度"
            }
        },
        {
            "type": 71,
            "name": {
                "en": "Wheelchair Run Pace",
                "cn": "轮椅跑步速度"
            }
        },
        {
            "type": 72,
            "name": {
                "en": "Tai Chi",
                "cn": "太极"
            }
        },
        {
            "type": 73,
            "name": {
                "en": "Mixed Cardio",
                "cn": "混合有氧"
            }
        },
        {
            "type": 74,
            "name": {
                "en": "Hand Cycling",
                "cn": "手动骑行"
            }
        },
        {
            "type": 75,
            "name": {
                "en": "Disc Sports",
                "cn": "飞盘运动"
            }
        },
        {
            "type": 76,
            "name": {
                "en": "Fitness Gaming",
                "cn": "健身游戏"
            }
        },
        {
            "type": 77,
            "name": {
                "en": "Cardio Dance",
                "cn": "有氧舞蹈"
            }
        },
        {
            "type": 78,
            "name": {
                "en": "Social Dance",
                "cn": "社交舞蹈"
            }
        },
        {
            "type": 79,
            "name": {
                "en": "Pickleball",
                "cn": "匹克球"
            }
        },
        {
            "type": 80,
            "name": {
                "en": "Cooldown",
                "cn": "冷却"
            }
        },
        {
            "type": 82,
            "name": {
                "en": "Swim Bike Run",
                "cn": "多项目运动"
            }
        },
        {
            "type": 83,
            "name": {
                "en": "Transition",
                "cn": "过渡"
            }
        },
        {
            "type": 84,
            "name": {
                "en": "Underwater Diving",
                "cn": "水下潜水"
            }
        }
    ]
    """
