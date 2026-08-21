-- Locale/tips_zhCN.lua — 简体中文攻略正文覆盖
-- 技能名保留英文标识，操作说明使用中文，方便与施法条和上游攻略核对。
local ADDON_NAME, KwikTip = ...

if GetLocale() ~= "zhCN" then return end

KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID or {}
KwikTip.AREA_OVERRIDE_BY_ID = KwikTip.AREA_OVERRIDE_BY_ID or {}

local boss = KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID
local area = KwikTip.AREA_OVERRIDE_BY_ID

-- Venomfall Deeps — IDs and localized encounter name verified from the live
-- zhCN runtime log. Mechanics remain intentionally conservative until combat
-- observations are available; never leave the persistent HUD body blank.
boss[3525] = {
    name = "阿兹塔雷克",
    tip = "该首领的详细攻略仍在整理；目前没有足够的实战记录可以可靠描述机制，请以游戏内技能提示为准。",
}

-- ============================================================
-- Murder Row
-- ============================================================
boss[3101] = { -- Kystia Manaheart
    notes = {
        { role = "healer", text = "Nibbles 在 20% 生命值引导 Destabilized 时开启大治疗技能；100% 伤害增幅窗口期间全队承受高额伤害。" },
        { role = "general", text = "躲避 Fel Nova 范围伤害；让 Nibbles 背对队伍，避开 Fel Spray 旋转正面攻击。" },
        { role = "general", text = "尽快驱散 Corroding Spittle；Mirror Images 出现期间酌情开启个人减伤。" },
        { role = "interrupt", text = "Mirror Images（5 个）：全部控制或打断。" },
        { role = "tank", text = "驱散首领的 Felshield 层数；Chaos Barrage 先命中坦克再跳向其他玩家，Mirror Images 存活时尤其危险。" },
    },
}
boss[3102] = { -- Zaen Bladesorrow
    notes = {
        { role = "general", text = "Murder in a Row：每人分别躲到一个木桶后规避流血；同时躲避 Same-Day Delivery 的滚桶。" },
        { role = "dps", text = "被 Fire Bomb 点名时靠近并顺劈 Fel-Infused Freight，摧毁它可停止全队伤害。" },
        { role = "healer", text = "Killing Spree 范围引导时开启治疗技能，场上存在 Fel-Infused Freight 时压力更大。" },
        { role = "tank", text = "Envenom 施法时开启减伤，并用毒药驱散移除减益。" },
    },
}
boss[3103] = { -- Xathuux the Annihilator
    notes = {
        { role = "general", text = "Infernal Crush 时分散，避免伤害波及队友；若与 Demonic Rage 重叠则开启个人减伤。" },
        { role = "tank", text = "让 Legion Strike 正面攻击背对队伍。Demonic Rage 期间沿场地边缘风筝首领，每次生成的伤害区不要占用超过半个房间。" },
        { role = "dps", text = "Axe Toss 点名时移动到首领旁，军团战斧生成后立即转火；把爆发技能留给 Demonic Rage 的伤害增幅阶段。" },
        { role = "healer", text = "Infernal Crush 与 Demonic Rage 重叠的大伤害时开启治疗技能。" },
    },
}
boss[3105] = { -- Lithiel Cinderfury
    notes = {
        { role = "interrupt", text = "按轮次打断 Chaos Bolt；Wild Imp 的 Felfire Burst 也必须打断。" },
        { role = "tank", text = "将首领拉离锁定坦克且无法击杀的 Infernal，并接住 Summon Vilefiend 召唤的小怪。" },
        { role = "dps", text = "在 Malefic Wave 接触小怪前将其全部顺劈击杀，否则小怪会获得 Malefic Empowerment；及时处理 Fingers of Gul'dan 召唤的 Wild Imp。" },
        { role = "general", text = "Fingers of Gul'dan 时分散，但尽量让圆圈相互重叠；Malefic Wave 读条结束后通过 Demonic Gateway 前往安全侧。" },
        { role = "healer", text = "注意 Searing Fel Flame 持续造成的全队脉冲伤害。" },
    },
}

-- ============================================================
-- Den of Nalorakk
-- ============================================================
boss[3207] = { -- The Hoardmonger
    notes = {
        { role = "general", text = "首领在 90%／70%／40% 生命值撤退并施放 Resourceful Measures；离开强化后的正面攻击和地面区域。" },
        { role = "dps", text = "肉堆激活时准备应对击退范围伤害；骨堆激活时躲避 Bonespike Slam 正面攻击。Rotten Mushroom 必须在 12 秒内分摊，否则触发 Putrid Burst。" },
        { role = "healer", text = "肉堆的 Hearty Bellow 会造成范围击退和持续伤害，提前抬血；蘑菇分摊后驱散 Toxic Spores 毒药。" },
    },
}
boss[3208] = { -- Sentinel of Winter
    notes = {
        { role = "general", text = "将 Raging Squall 龙卷风集中引到同一位置，然后绕场转移。" },
        { role = "dps", text = "躲避 Shattering Frostspike 圆圈并击杀生成的小怪；打断小怪的 Winter's Shroud，小怪死亡时分摊 Rimeshatter。" },
        { role = "healer", text = "尽快驱散 Glacial Torment 持续伤害；Frozen Tempest 持续期间开启治疗技能。冰面会使角色滑动。" },
    },
}
boss[3209] = { -- Nalorakk
    notes = {
        { role = "general", text = "绝不能让 Zul'jarra 被 Forceful Slam 或冲锋幻影命中，否则会触发 Demoralizing Scream。" },
        { role = "dps", text = "Fury of the War God：围绕 Zul'jarra 站成一圈，拦截冲锋幻影；Overwhelming Onslaught 期间不要背对幻影。" },
        { role = "healer", text = "Overwhelming Onslaught 期间，队伍躲在 Zul'jarra 护盾后承受三次大伤害，开启治疗技能。" },
    },
}
area["2825:2"] = { tip = "此区域有野兽巡逻，拉怪时注意巡逻路线。" }

-- ============================================================
-- Magisters' Terrace（截图所在副本）
-- ============================================================
boss[3071] = { -- Arcanotron Custos
    notes = {
        { role = "general", text = "Refueling Protocol（0 能量）：读条前将首领拉到房间角落，让球体汇聚在同一方向，方便接球；伤害增幅阶段开启爆发技能。" },
        { role = "general", text = "Arcane Expulsion：造成范围伤害并击退，同时留下伤害区；让首领朝向场地边缘，使伤害区落在战斗区域之外。" },
        { role = "general", text = "Arcane Residue 会造成减速和持续伤害，可用魔法驱散或自由类效果移除，能显著降低总体承伤。" },
        { role = "general", text = "Refueling Protocol 的球体会叠加 Unstable Energy 持续伤害；需要连续接多个球时开启减伤。" },
        { role = "tank", text = "Repulsing Slam 时站在楼梯边缘可完全阻止击退；猛击命中前开启减伤。" },
        { role = "healer", text = "驱散两名随机玩家身上的魔法减益 Ethereal Shackles。" },
    },
}
boss[3072] = { -- Seranel Sunlash
    notes = {
        { role = "general", text = "首领达到 100 能量时，必须在 Wave of Silence 读条结束前进入 Suppression Zone，否则会被平静 8 秒。" },
        { role = "general", text = "进入 Suppression Zone 解除 Runic Mark（Feedback）；区域会清除你的增益，两名标记玩家应保持距离，避免区域同时扫到队伍。" },
        { role = "general", text = "及时驱散首领身上的 Hastening Ward。" },
        { role = "general", text = "Null Reaction 会组合攻击两名被点名玩家，被点名时开启个人减伤。" },
    },
}
boss[3073] = { -- Gemellus
    notes = {
        { role = "general", text = "开场及 50% 生命值时生成分身，所有分身共享生命值；顺劈输出，并沿 Neural Link 箭头找到属于自己的分身后触碰它。" },
        { role = "general", text = "Astral Grasp 会把玩家拉向分身，移动抵抗拉拽并继续寻找正确分身。" },
        { role = "general", text = "被 Cosmic Sting 点名时远离队伍放置伤害区。" },
    },
}
boss[3074] = { -- Degentrius
    notes = {
        { role = "general", text = "Void Torrent 光束会分割场地；两侧各留一名玩家分摊 Unstable Void Essence 的弹跳，漏接会获得持续 40 秒的持续伤害。" },
        { role = "general", text = "Devouring Entropy 给玩家施加不同持续时间的减益；持续时间较长时开启个人减伤，并将自己的球朝队友方向引导。" },
        { role = "general", text = "绝不要站进 Void Torrent 光束，否则会被昏迷。" },
        { role = "tank", text = "Hulking Fragment 需要魔法驱散时退离近战范围，驱散后会留下伤害区。" },
        { role = "healer", text = "Entropy Blast 会造成无法规避的全队伤害，提前安排治疗技能；改变站位不能降低伤害。" },
    },
}
area["2811:1"] = { tip = "优先打断 Arcane Magister 的 Polymorph（随机点名玩家）。不要一次拉太多 Animated Codex，其 Arcane Volley 会持续造成全队伤害。驱散 Lightward Healer 的 Holy Fire。" }
area["2811:4"] = { tip = "每次打断 Void Infuser 的 Terror Wave。错开击杀 Brightscale Wyrm，避免同时死亡让 Energy Release 在队伍中连锁。对 Shadowrift Voidcaller 的 Consuming Shadows 使用视野阻断。" }

-- ============================================================
-- The Blinding Vale
-- ============================================================
boss[3199] = { -- Lightblossom Trinity
    notes = {
        { role = "general", text = "Lightblossom Beam 会把三个 Fertile Loam 圆圈变为分摊圈；立即进入，阻止 Lightbloom Overgrowth 全队伤害。引导结束后圆圈会变成 Light-Scorched Earth 禁区。" },
        { role = "tank", text = "Bedrock Slam 时开启减伤，随后在下一次施放前把首领拉离 Light-Scorched Earth。" },
        { role = "interrupt", text = "按轮次打断 Kezkitt 随机点名的 Light Bolt；躲开穿过三个圆圈的 Lightsower Dash 直线。" },
        { role = "general", text = "被 Lekshi 的 Thornblade 点名时远离队友，避免顺劈；Lekshi 跳向你时离开效果区域，并开启减伤或清除流血。" },
    },
}
boss[3200] = { -- Ikuzz the Light Hunter
    notes = {
        { role = "general", text = "Bloodthirsty Gaze 会让 Ikuzz 锁定随机玩家；被锁定者远离首领，并把他引过已有根须以摧毁根须。" },
        { role = "dps", text = "躲避地面的 Bloodthorn Roots，50% 生命值 Lightcrazed Frenzy 期间尤其危险。被定身时转火根须或使用自由类效果；Verdant Stomp 后集合，让玩家脚下生成的根须便于顺劈。" },
        { role = "healer", text = "Thorncaller Roar 会持续造成团队伤害，提前准备治疗技能。" },
    },
}
boss[3201] = { -- Lightwarden Ruia
    notes = {
        { role = "interrupt", text = "枭兽形态下持续打断 Warden's Wrath，降低坦克承伤。" },
        { role = "general", text = "躲避 Lightfall 圆圈；三名玩家获得 Lightfire 后集合，减益结束时躲开龙卷风。" },
        { role = "general", text = "熊形态下，被 Pulverizing Strikes 点名者分散，避免正面攻击波及队友；坦克注意 Mangling Claws 被动效果。" },
        { role = "healer", text = "用自疗、流血清除或减伤移除 Grievous Thrash；低于 40% 后 Haranir 形态每 8 秒轮换全部四种技能，安排治疗技能。" },
    },
}
boss[3202] = { -- Ziekket
    notes = {
        { role = "general", text = "平均分摊 Lightbloom's Essence 球体，别让它们碰到首领；首领吸收会触发 Fluorescent Outburst（范围伤害并叠加护盾）。玩家接球会获得 Lightbloom's Might（伤害和治疗提高 10%，同时承受神圣持续伤害）。" },
        { role = "dps", text = "顺劈 Awaken the Lightbloom 召唤的小怪并打断 Lightspore Shot。鞭笞者进入 Dormant 后，用首领的 Concentrated Lightbeam 照射它们，将其融成 Lightsap 伤害区；让首领和小怪靠近平台边缘并躲开光束和伤害区。" },
        { role = "healer", text = "Oozing Xylem 整场战斗持续造成全队神圣伤害，保持全队血量。" },
        { role = "tank", text = "Thornspike 会穿刺、施加流血并击退，使用减伤或流血清除。" },
    },
}

-- ============================================================
-- Voidscar Arena
-- ============================================================
boss[3285] = { -- Taz'Rah
    notes = {
        { role = "general", text = "Nether Dash 会依次沿直线穿过每名玩家；在场边分散，并把阴影伤害区集中放置，让 Umbral Rupture 区域聚在一起。" },
        { role = "tank", text = "Void Blast 前开启减伤，避免被击退进伤害区。" },
        { role = "general", text = "Dark Bloom 会从伤害区发射球体；躲避球体，并在 Umbral Rupture 后继续绕场移动。" },
    },
}
boss[3286] = { -- Atroxus
    notes = {
        { role = "healer", text = "Poison Splash 会造成全队伤害，确保玩家离开 Mind-Numbing Poison 伤害区。" },
        { role = "general", text = "Noxious Breath 是正面攻击；靠近首领站位以便快速躲开。" },
        { role = "dps", text = "Monstrous Roar 后立即转火 Toxic Creeper，它存活时会持续造成全队伤害。" },
        { role = "tank", text = "风筝锁定你的 Toxic Creeper；Sickening Bite 层数会让 Hulking Claw 变得致命，Hulking Claw 前开启减伤。" },
    },
}
boss[3287] = { -- Charonus
    notes = {
        { role = "general", text = "躲避 Unstable Singularity 球体（Atomized）；Cosmic Crash 时分散，避免伤害波及队友。" },
        { role = "general", text = "Gravitic Orb 会锁定输出职业；把球引过 Unstable Singularity 可同时摧毁两者，使用减伤或自由类效果移除 Condensed Mass。" },
        { role = "tank", text = "让 Dark Waves 正面攻击背对队伍。" },
        { role = "general", text = "Void Cascade 发射投射物时远离首领躲避，其他玩家也要离开路径。" },
    },
}

-- ============================================================
-- Kings' Rest
-- ============================================================
boss[2139] = { -- The Golden Serpent
    notes = {
        { role = "general", text = "Spit Gold 的伤害区靠近已有伤害区放置；Lucre's Call 会把它们变成 Animated Gold，立即顺劈并减速／控制，别让它们强化首领。" },
        { role = "healer", text = "Serpentine Gust 引导期间使用团队减伤或治疗技能。" },
        { role = "tank", text = "Tail Thrash 伤害不高，正常承受即可。" },
    },
}
boss[2142] = { -- Mchimba the Embalmer
    notes = {
        { role = "general", text = "躲避 Drain Fluids 圆圈；被点名者开启减伤，或使用脱战技能终止引导。" },
        { role = "healer", text = "若 Drain Fluids 完整引导，将目标治疗到 90% 以上以移除减益；Awakening Slam 前抬满全队。" },
        { role = "general", text = "Burn Corruption 的火焰伤害区放在远离首领和石棺的位置，避免堵住路线。" },
        { role = "dps", text = "Awakening Slam 后顺劈两个 Half-Finished Mummy，并打断 Wretched Discharge。" },
        { role = "general", text = "Entomb 时分散，找到正在晃动的石棺并救出玩家，避免额外木乃伊生成。" },
    },
}
boss[2140] = { -- The Council of Tribes
    notes = {
        { role = "general", text = "Severing Axe 点名者清除流血或开启减伤；躲避 Whirling Axes 初始范围伤害及旋转飞斧。" },
        { role = "tank", text = "把 Kula 坦在场地中央，她死亡后 Whirling Axes 仍会继续。Debilitating Backhand 时风筝或开启大减伤；Arc Lightning 总会从坦克弹射。" },
        { role = "general", text = "全队在安全位置集合分摊 Barrel Through；Aka'ali 死亡后该机制仍会继续。" },
        { role = "interrupt", text = "打断 Poison Nova。" },
        { role = "dps", text = "Call the Elements 图腾击杀顺序：Explosive Totem → Thundering Totem → Torrent Totem。" },
    },
}
boss[2143] = { -- Dazar, the First King
    notes = {
        { role = "general", text = "优先集火 Reban；躲避 Hunting Leap 正面攻击，并打断 Deathly Roar。" },
        { role = "general", text = "Aerial Smash 后分散。首领在 80% 生命值骑乘后，Quaking Leap 会命中四人；最远目标可用脱战技能取消。" },
        { role = "tank", text = "Blade Combo 伤害逐次提高，提前开减伤；骑乘阶段 Savage Maul 会紧接在它之前，使用流血清除。Gilded Destruction 期间让首领背对队伍，近战攻击会变成正面攻击。" },
        { role = "healer", text = "Gilded Destruction 全队伤害和 Quaking Leap 时开启治疗技能。" },
        { role = "general", text = "躲避 Impaling Spear 圆圈；被命中后开启减伤或清除流血。" },
    },
}

-- ============================================================
-- Temple of Sethraliss
-- ============================================================
boss[2124] = { -- Adderis and Aspix
    notes = {
        { role = "general", text = "Storm Blessed 免疫会在首领达到 40% 生命值时交换；攻击当前没有免疫的目标。" },
        { role = "general", text = "Gale Force 会击退全队，可贴墙阻止滑动；随后必接 Thunder And Lightning，全队在近战集合分摊。" },
        { role = "general", text = "Tempest Winds 点名的两名玩家离开队伍，把伤害区放在远处。" },
        { role = "tank", text = "Adderis 获得 Overload 时开启减伤；Adderis 死亡后 Aspix 会狂暴，机制频率提高。" },
        { role = "healer", text = "重点治疗被 Gust 点名的玩家。" },
    },
}
boss[2125] = { -- Merektha
    notes = {
        { role = "tank", text = "每次 Lightning Bite 读条前开启减伤。把 Storm Serpent 坦在已有伤害区附近或房间边缘，它们施放 Storm Catalyst 时会留下新伤害区。" },
        { role = "general", text = "Knot of Snakes 会点名两人；近战集合，用一次范围控制摧毁束缚，然后在首领脚下顺劈蛇群。" },
        { role = "general", text = "Thunder Spit 圆圈放在场地外围，并为持续伤害开启减伤；注意站位，别让 Serpentstorm 把你击退进伤害区。" },
        { role = "healer", text = "准备治疗 Serpentstorm 全队伤害；Burrow 阶段持续抬血。打断小怪 Poison Spit，并按需驱散毒药持续伤害。" },
        { role = "interrupt", text = "Burrow 阶段打断小怪的 Poison Spit。" },
    },
}
boss[2126] = { -- Galvazzt
    notes = {
        { role = "general", text = "每轮出现三个 Lightning Spire；由非坦克站在尖塔与首领之间挡住能量。能量满会施放 Consume Charge，导致灭团。" },
        { role = "tank", text = "移动首领方便队友挡住尖塔；Induction 留下伤害区后重新站位，尖塔分摊期间开启减伤。" },
        { role = "healer", text = "Lightning Spire 每轮都会持续造成高额伤害，合理分配治疗技能。" },
    },
}
boss[2127] = { -- Avatar of Sethraliss
    notes = {
        { role = "general", text = "优先击杀 Corrupted Guardian；死亡时造成 20 码范围伤害并生成三个 Corrupted Lifeforce，必须在 4.5 秒 Corruption Burst 前接住。接球会叠加提高治疗量和物理承伤的减益，优先由输出职业接，或由开减伤的坦克接。" },
        { role = "general", text = "Faithless Tormentor 的 30 秒波次中先控制再范围击杀；每只都会为 Avatar 恢复 0.6% 生命值，并注意可叠加的 Shadowlash 减益。" },
        { role = "interrupt", text = "打断 Twisted Hexxer 的 Flame Shock；Latent Hex 伤害区放到房间外围。" },
        { role = "tank", text = "Corrupted Guardian 的 Vile Charge 点名坦克时开启减伤，Tainted Strike 重击前也要减伤。" },
        { role = "healer", text = "Essence Defiler 死亡后，在 Faithless Tormentor 波次中集中治疗 Avatar，并抬住分摊造成的持续伤害。" },
    },
}

-- ============================================================
-- Ruby Life Pools
-- ============================================================
boss[2609] = { -- Melidrussa Chillworn
    notes = {
        { role = "general", text = "全队集合，把 Hailburst 冰块集中引到同一位置；场地被占用后沿房间逐步转移。" },
        { role = "general", text = "Chillstorm 点名者远离队伍放置；被拉向中心时用治疗和减伤存活。" },
        { role = "interrupt", text = "打断 Frigid Shard，降低坦克承伤。" },
        { role = "tank", text = "首领达到 66%／33% 生命值时，接住 Awaken Whelps 召唤的 Infused Whelp。" },
        { role = "dps", text = "预留伤害快速击破 Ice Bulwark，尽快结束 Frost Overload 引导。" },
    },
}
boss[2606] = { -- Kokia Blazehoof
    notes = {
        { role = "general", text = "Ritual of Blazebinding 点名时远离队伍，避免伤害波及队友；随后优先击杀生成的 Blazebound Firestorm。" },
        { role = "general", text = "把 Molten Boulder 投射物引向不会阻挡路线的位置；它碰到地形后会爆炸。" },
        { role = "interrupt", text = "打断 Blaze Volley。" },
        { role = "healer", text = "准备治疗 Blazebound Firestorm 小怪的 Inferno。" },
        { role = "tank", text = "每次 Searing Blows 读条前开启减伤。" },
    },
}
boss[2623] = { -- Kyrakka and Erkhart Stormvein
    notes = {
        { role = "general", text = "第一阶段把 Inferno Spit 伤害区放到队伍外，并躲避 Roaring Flamebreath 正面攻击；按 Winds of Change 的西北→西南→东南→东北方向摆放，让风把伤害区吹离场地。" },
        { role = "general", text = "Interrupting Cloudburst 完成时停止施法。第二阶段（50%）Inferno Spit 会持续点名三人直到首领死亡，集中爆发尽快结束战斗。" },
        { role = "interrupt", text = "Interrupting Cloudburst 即将完成时停止施法。" },
        { role = "healer", text = "Stormslam 后驱散坦克身上的魔法减益，该减益会提高受到的伤害。" },
        { role = "tank", text = "Stormslam 前开启减伤；命中后会留下魔法减益，让治疗在下一次施放前驱散。" },
    },
}

-- ============================================================
-- Altar of Fangs
-- ============================================================
boss[3456] = { -- Rav'i
    notes = {
        { role = "general", text = "分摊所有 Messy Eater 区域；集中承伤可快速打破护盾，降低治疗压力。" },
        { role = "general", text = "Triple Shot 时适度分散，避免伤害波及队友；躲避 Regurgitate 波浪直线。" },
        { role = "tank", text = "注意 Bone Pile：Ssscavenging 前把首领拉到没有 Twinfang 尸体的骨堆，选错会触发 Feeding Frenzy；Hydrastrike 前开启减伤。" },
        { role = "healer", text = "Ravenous Stomp 前抬满全队；有人被 Regurgitate 命中后驱散疾病。" },
    },
}
boss[3457] = { -- The Writhing Coil
    notes = {
        { role = "general", text = "Vindictive Onslaught：先躲避 Burrowing Charge 直线，再把 Venom Jet 正面攻击引离队伍。" },
        { role = "general", text = "Death Rattle 时用位移迅速拉断连线，阻止高额全队伤害；控制并集中五只 Uncoiled Writhe，开启爆发击杀。25 秒后躲避 Undermining 冲击波直线。" },
        { role = "healer", text = "Synchronized Venom 在大部分战斗时间持续跳伤，需要稳定的全队治疗。" },
        { role = "interrupt", text = "Toxic Atrophy 会连续施放三次，每次都必须打断；三只 Uncoiled Writhe 也会施放，使用控制或打断。" },
        { role = "tank", text = "Tail Scythe 伤害可正常处理；Venom Jet 期间让首领背对队伍。" },
    },
}
boss[3458] = { -- Zul'jan
    notes = {
        { role = "general", text = "Ritual Of The Fang 中分摊全部四道光束；Ritual Venom 到期前站进 Boneslicer 清除层数，每次最多清八层；躲避 Axegrinder 旋转飞斧。" },
        { role = "general", text = "Bloodletting 留下的伤害区持续 30 秒，合理规划放置位置。" },
        { role = "tank", text = "Chop Down 连击前开启减伤；若身上仍有 Ritual Venom 层数会生成伤害区，提前规划站位。" },
        { role = "healer", text = "Ritual Of The Fang 光束分摊期间开启治疗技能。" },
    },
}
