local ADDON_NAME = "LuhUtilities"
local LS = LuhUtilities
LS.MountVars = LS.MountVars or {}
local MV = LS.MountVars
MV.MountList = MV.MountList or {}
MV.MountSpellList = MV.MountSpellList or {}
MV.MountItemList = MV.MountItemList or {}
MV.Player = MV.Player or {}
MV.Localize = MV.Localize or { Zone = {}, String = {}, Skill = {} }
GoGo_Variables = MV

﻿
---------
--function GoGo_Localize()
---------

-- Constants
	GoGo_Variables.Localize.ColdWeatherFlying = 54197
	GoGo_Variables.Localize.FastFlightForm = 40120
	GoGo_Variables.Localize.FlightForm = 33943
	GoGo_Variables.Localize.AquaForm = 1066
	GoGo_Variables.Localize.TravelForm = 783
	GoGo_Variables.Localize.CatForm = 768
	GoGo_Variables.Localize.GhostWolf = 2645
	GoGo_Variables.Localize.CrusaderAura = 32223
	GoGo_Variables.Localize.AspectCheetah = 5118
--	GoGo_Variables.Localize.AspectPack = 13159

-- Default to english, localized below if translation is available (see http://wow.curseforge.com/projects/gogomount/localization/)
	GoGo_Variables.Localize.Zone.TwistingNether = "Twisting Nether"
	GoGo_Variables.Localize.Zone.TheFrozenSea = "The Frozen Sea"
	GoGo_Variables.Localize.Zone.AQ40 = "Ahn'Qiraj"
	GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
	GOGO_SZONE_THEUNDERBELLY = "The Underbelly"
	GOGO_SZONE_KRASUSLANDING = "Krasus' Landing"
	GOGO_SZONE_THEVIOLETCITADEL = "The Violet Citadel"
	GoGo_Variables.Localize.Zone.Wintergrasp = "Wintergrasp"
	GoGo_Variables.Localize.Zone.SholazarBasin = "Sholazar Basin"
	GoGo_Variables.Localize.Zone.TheStormPeaks = "The Storm Peaks"
	GOGO_ZONE_ICECROWN = "Icecrown"
	GOGO_ZONE_THEOCULUS = "The Oculus"
	GOGO_SKILL_ENGINEERING = "Engineering"
	GOGO_SKILL_TAILORING = "Tailoring"
	GOGO_SKILL_RIDING = "Riding"
	GOGO_STRING_ENABLEAUTODISMOUNT = "Enable automatic dismount"
	GOGO_STRING_DRUIDSINGLECLICK = "Single click to shift from form to travel forms"
	GoGo_Variables.Localize.String.DruidFlightPreference = "Always use flight forms instead of when moving only"
	GOGO_STRING_SAMEEPICFLYSPEED = "Consider 310% and 280% mounts the same speed"
	GOGO_STRING_DISABLEUPDATENOTICES = "Disable update notices"
	GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Disable unknown mount notices"
	GOGO_STRING_UNKNOWNMOUNTFOUND = "An unknown mount has been found in you list of mounts.  Please report this so that it can be added to future versions of GoGoMount."
	GOGO_STRING_NEWVERSIONFOUND = "GoGoMount update is available and is being used by "
	GOGO_STRING_FAVORITES = "Favorites"
	GOGO_STRING_CURRENTZONEFAVORITES = "Current Zone Favorites"
	GOGO_STRING_GLOBALFAVORITES = "Global Favorites"
	GOGO_STRING_GLOBALPREFERENCES = "Global Preferences"
	GOGO_TALENT_FERALSWIFTNESS = "Feral Swiftness"
	GOGO_TALENT_IMPROVEDGHOSTWOLF = "Improved Ghost Wolf"

	if GetLocale() == "frFR" then

		GoGo_Variables.Localize.Zone.TwistingNether = "Le Néant distordu"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "La mer Gelée"
		GoGo_Variables.Localize.Zone.AQ40 = "Temple d'Ahn'Qiraj"
		GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
		GOGO_SZONE_THEUNDERBELLY = "Les Entrailles"
		GOGO_SZONE_KRASUSLANDING = "Aire de Krasus"
		GOGO_SZONE_THEVIOLETCITADEL = "Citadelle Pourpre"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Joug-d'hiver"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Bassin de Sholazar"
		GOGO_ZONE_ICECROWN = "La Couronne de glace"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "Les pics Foudroyés"
		GOGO_ZONE_THEOCULUS = "L'Oculus"

		GOGO_SKILL_ENGINEERING = "Ingénierie"
		GOGO_SKILL_TAILORING = "Couture"
		GOGO_SKILL_RIDING = "Monte"

		GOGO_STRING_ENABLEAUTODISMOUNT = "Activer la descente de monture automatique"
		GOGO_STRING_DRUIDSINGLECLICK = "Clic pour passer à la monture suivante"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "Une monture inconnue a été trouvée dans votre liste. Veuillez la communiquer afin qu'elle soit ajoutée à une future version de GoGoMount."
		GOGO_STRING_NEWVERSIONFOUND = "Une mise à jour de GoGoMount est disponible et est utilisée par "
		GOGO_STRING_SAMEEPICFLYSPEED = "Considérer que les montures 280% et 310% ont la même vitesse"
		GOGO_STRING_DISABLEUPDATENOTICES = "Désactiver les annonces de mise à jour"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Désactiver les annonces de monture inconnue"
		GOGO_STRING_FAVORITES = "Favoris"
		GOGO_STRING_GLOBALPREFERENCES = "Préférences globales"
		GOGO_STRING_CURRENTZONEFAVORITES = "Favoris de la zone actuelle"
		GOGO_STRING_GLOBALFAVORITES = "Favoris globaux"
	
		GOGO_TALENT_FERALSWIFTNESS = "Célérité farouche"
	
		BINDING_NAME_GOGOBINDING = "Monter/descendre de la monture"
		BINDING_NAME_GOGOBINDING2 = "Monter/descendre de la monture non volante"
		BINDING_NAME_GOGOBINDING3 = "Monter/descendre de la monture à passager"

	elseif GetLocale() == "deDE" then

		GoGo_Variables.Localize.Zone.TwistingNether = "Wirbelnder Nether"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "Die gefrorene See"
		GoGo_Variables.Localize.Zone.AQ40 = "Tempel von Ahn'Qiraj"
		GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
		GOGO_SZONE_THEUNDERBELLY = "Die Schattenseite"
		GOGO_SZONE_KRASUSLANDING = "Krasus' Landeplatz"
		GOGO_SZONE_THEVIOLETCITADEL = "Die Violette Zitadelle"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Tausendwintersee"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Sholazarbecken"
		GOGO_ZONE_ICECROWN = "Eiskrone"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "Der Sturmgipfel"
		GOGO_ZONE_THEOCULUS = "Das Oculus"
	
		GOGO_SKILL_ENGINEERING = "Ingenieurskunst"
		GOGO_SKILL_TAILORING = "Schneiderei"
		GOGO_SKILL_RIDING = "Reiten"
	
		GOGO_STRING_ENABLEAUTODISMOUNT = "Automatisches Absitzen erlauben"
		GOGO_STRING_NEWVERSIONFOUND = "Eine aktualisierte Version von GoGoMount ist verfügbar und wird verwendet von "
		GOGO_STRING_SAMEEPICFLYSPEED = "310% und 280% Geschwindigkeitsbonus gleichsetzen"
		GOGO_STRING_DISABLEUPDATENOTICES = "Updatenachrichten deaktivieren"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Ankündigungen über unbekannte Mounts deaktivieren"
		GOGO_STRING_DRUIDSINGLECLICK = "Einfacher Klick für den Wechsel in Reisegestalten"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "Ein unbekanntes Reittier wurde in deiner Liste entdeckt. Bitte melde es, damit es in zukünftige Versionen von GoGoMount integriert werden kann."
		GOGO_STRING_FAVORITES = "Favoriten"
		GOGO_STRING_GLOBALPREFERENCES = "Globale Präferenzen"
		GOGO_STRING_GLOBALFAVORITES = "Globale Favoriten"
		GOGO_STRING_CURRENTZONEFAVORITES = "Favoriten der aktuellen Zone"
		GOGO_STRING_NEWVERSIONFOUND = "Eine aktualisierte Version von GoGoMount ist verfügbar und wird verwendet von "
		
		GOGO_TALENT_FERALSWIFTNESS = "Schnelligkeit der Wildnis"
	
		BINDING_NAME_GOGOBINDING = "Aufsitzen/Absitzen"
		BINDING_NAME_GOGOBINDING2 = "Aufsitzen/Absitzen (nichtfliegend)"
		BINDING_NAME_GOGOBINDING3 = "Aufsitzen/Absitzen bei Fahrgast-Mounts"

	elseif GetLocale() == "esES" then

		GoGo_Variables.Localize.Zone.TwistingNether = "El Vacío Abisal"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "El Mar Gélido"
		GoGo_Variables.Localize.Zone.AQ40 = "Templo de Ahn'Qiraj"
		GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
		GOGO_SZONE_THEUNDERBELLY = "Los Bajos Fondos"
		GOGO_SZONE_KRASUSLANDING = "Alto de Krasus"
		GOGO_SZONE_THEVIOLETCITADEL = "La Ciudadela Violeta"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Conquista del Invierno"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Cuenca de Sholazar"
		GOGO_ZONE_ICECROWN = "Corona de Hielo"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "Las Cumbres Tormentosas"
		GOGO_ZONE_THEOCULUS = "El Oculus"

		GOGO_SKILL_ENGINEERING = "Ingeniería"
		GOGO_SKILL_TAILORING = "Sastrería"
		GOGO_SKILL_RIDING = "Equitación"

		GOGO_STRING_ENABLEAUTODISMOUNT = "Activar desmonte automático"
		GOGO_STRING_DRUIDSINGLECLICK = "Un click en mayúsculas (shift) para las formas de viaje"
		GOGO_STRING_SAMEEPICFLYSPEED = "Considerar 310% y 280% como la misma velocidad"
		GOGO_STRING_DISABLEUPDATENOTICES = "Desactivar notificaciones de actualizaciones"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Desactivar notificaciones de monturas desconocidas"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "Una montura desconocida ha sido encontrada en la lista de tus monturas. Por favor, reporte esto para que pueda ser añadido en futuras versiones de GoGoMount."
		GOGO_STRING_NEWVERSIONFOUND = "Una nueva actualización de GoGoMount está disponible y es usada por "
		GOGO_STRING_FAVORITES = "Favoritos"
		GOGO_STRING_CURRENTZONEFAVORITES = "Favoritos de Zona Actual"
		GOGO_STRING_GLOBALFAVORITES = "Favoritos Globales"
		GOGO_STRING_GLOBALPREFERENCES = "Preferencias Globales"
	
		GOGO_TALENT_FERALSWIFTNESS = "Presteza feral"
	
		BINDING_NAME_GOGOBINDING = "Montar/Desmontar"
		BINDING_NAME_GOGOBINDING2 = "Montar/Desmontar (no voladora)"
		BINDING_NAME_GOGOBINDING3 = "Montar/Desmontar Monturas de Pasajeros"
	
	elseif GetLocale() == "esMX" then
	
		GoGo_Variables.Localize.Zone.TwistingNether = "El Vacío Abisal"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "El Mar Gélido"
		GoGo_Variables.Localize.Zone.AQ40 = "Templo de Ahn'Qiraj"
		GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
		GOGO_SZONE_THEUNDERBELLY = "Los Bajos Fondos"
		GOGO_SZONE_KRASUSLANDING = "Alto de Kraus"
		GOGO_SZONE_THEVIOLETCITADEL = "La Ciudadela Violeta"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Conquista del Invierno"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Cuenca de Sholazar"
		GOGO_ZONE_ICECROWN = "Corona de Hielo"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "Las Cumbres Tormentosas"
		GOGO_ZONE_THEOCULUS = "El Oculus"
	
		GOGO_SKILL_ENGINEERING = "Ingeniería"
		GOGO_SKILL_TAILORING = "Sastrería"
		GOGO_SKILL_RIDING = "Equitación"
	
		GOGO_STRING_ENABLEAUTODISMOUNT = "Activar desmonte automático"
		GOGO_STRING_DRUIDSINGLECLICK = "Un click en mayúsculas (shift) para las formas de viaje"
		GOGO_STRING_SAMEEPICFLYSPEED = "Considerar 310% y 280% como la misma velocidad"
		GOGO_STRING_DISABLEUPDATENOTICES = "Desactivar notificaciones de actualizaciones"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Desactivar notificaciones de monturas desconocidas"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "Una montura desconocida ha sido encontrada en la lista de tus monturas. Por favor, reporte esto para que pueda ser añadido en futuras versiones de GoGoMount."
		GOGO_STRING_NEWVERSIONFOUND = "Una nueva actualización de GoGoMount está disponible y es usada por "
		GOGO_STRING_FAVORITES = "Favoritos"
		GOGO_STRING_CURRENTZONEFAVORITES = "Favoritos de Zona Actual"
		GOGO_STRING_GLOBALFAVORITES = "Favoritos Globales"
		GOGO_STRING_GLOBALPREFERENCES = "Preferencias Globales"
	
		GOGO_TALENT_FERALSWIFTNESS = "Presteza feral"
	
		BINDING_NAME_GOGOBINDING = "Montar/Desmontar"
		BINDING_NAME_GOGOBINDING2 = "Montar/Desmontar (no voladora)"
		BINDING_NAME_GOGOBINDING3 = "Montar/Desmontar Monturas de Pasajeros"
	
	elseif GetLocale() == "koKR" then
	
		GoGo_Variables.Localize.Zone.TwistingNether = "뒤틀린 황천"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "얼어붙은 바다"
		GoGo_Variables.Localize.Zone.AQ40 = "안퀴라즈 사원"
		GoGo_Variables.Localize.Zone.Dalaran = "달라란"
		GOGO_SZONE_THEUNDERBELLY = "마법의 뒤안길"
		GOGO_SZONE_KRASUSLANDING = "크라서스 착륙장"
		GOGO_SZONE_THEVIOLETCITADEL = "보랏빛 성채"
		GoGo_Variables.Localize.Zone.Wintergrasp = "겨울손아귀 호수"
		GoGo_Variables.Localize.String.DruidFlightPreference = "항상 움직일때 비행 형태의 변신 사용"
		
		BINDING_NAME_GOGOBINDING = "타기/내리기"
		BINDING_NAME_GOGOBINDING2 = "타기/내리기 (나는 탈것 제외)"
		BINDING_NAME_GOGOBINDING3 = "2인승 탈것 타기/내리기"

		GOGO_STRING_GLOBALFAVORITES = "일반적인 즐겨찾기"
		GOGO_STRING_CURRENTZONEFAVORITES = "현재 지역 즐겨찾기"
		GOGO_STRING_GLOBALPREFERENCES = "일반 설정"
		GOGO_STRING_FAVORITES = "즐겨찾기"
		GOGO_STRING_USESHAPESHIFTFORMS = "변신 폼 사용"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "알 수 없는 탈것 안내 사용 중지"
		GOGO_STRING_DISABLEUPDATENOTICES = "업데이트 안내 사용 중지"
		GOGO_STRING_SAMEEPICFLYSPEED = "310%와 280%의 같은 속도의 탈것 고려"
		GOGO_STRING_NEWVERSIONFOUND = "GoGoMount 업데이트가 가능하고 사용됩니다. "
		GOGO_STRING_UNKNOWNMOUNTFOUND = "알 수 없는 탈것이 당신의 목록에서 발견되었습니다. 이것을 GoGoMount의 다음 버전에 추가될 수 있도록 알리십시오."
		GOGO_STRING_DRUIDSINGLECLICK = "변신 상태에서 다른 변신 형태로 한번의 클릭으로 변경"
		GOGO_STRING_ENABLEAUTODISMOUNT = "자동 탈것 내리기 사용"
		GOGO_TALENT_FERALSWIFTNESS = "야생의 기민함"
		GOGO_ZONE_THEOCULUS = "마력의 눈"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "폭풍우 봉우리"
		GoGo_Variables.Localize.Zone.SholazarBasin = "숄라자르 분지"
		GOGO_ZONE_ICECROWN = "얼음왕관"
		
		GOGO_SKILL_ENGINEERING = "기계공학"
		GOGO_SKILL_TAILORING = "재봉술"
		GOGO_SKILL_RIDING = "탈것 타기"
	
	elseif GetLocale() == "zhCN" then
	
		BINDING_NAME_GOGOBINDING = "召唤坐骑/解散坐骑"
		BINDING_NAME_GOGOBINDING2 = "召唤/解散坐骑 (非飞行坐骑)"
		BINDING_NAME_GOGOBINDING3 = "召唤/解散多人坐骑"
	
		GoGo_Variables.Localize.Zone.TwistingNether = "扭曲虚空"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "冰冻之海"
		GoGo_Variables.Localize.Zone.AQ40 = "安其拉神殿"  -- may need "temple" removed
		GoGo_Variables.Localize.Zone.Dalaran = "达拉然"
		GOGO_SZONE_THEUNDERBELLY = "达拉然下水道"
		GOGO_SZONE_KRASUSLANDING = "克拉苏斯平台"
		GOGO_SZONE_THEVIOLETCITADEL = "紫罗兰城堡"
		GoGo_Variables.Localize.Zone.Wintergrasp = "冬拥湖"
		GoGo_Variables.Localize.Zone.SholazarBasin = "索拉查盆地"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "风暴峭壁"
		GOGO_ZONE_ICECROWN = "冰冠冰川"
	
		GOGO_STRING_ENABLEAUTODISMOUNT = "开启自动解散坐骑"
		GOGO_STRING_DRUIDSINGLECLICK = "一键切换至旅行形态"
		GOGO_STRING_SAMEEPICFLYSPEED = "310%与280%的坐骑视作同一速度"
		GOGO_STRING_DISABLEUPDATENOTICES = "关闭更新提示"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "关闭未知坐骑提示"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "在您的坐骑列表中发现一个未知的坐骑.请报告以便在未来版本中加入"
		GOGO_STRING_NEWVERSIONFOUND = "GoGoMount 有新版本可更新 "
		GOGO_STRING_FAVORITES = "收藏"
		GOGO_STRING_CURRENTZONEFAVORITES = "当前地域收藏"
		GOGO_STRING_GLOBALFAVORITES = "全局收藏"
		GOGO_STRING_GLOBALPREFERENCES = "全局优先"
		
		GOGO_SKILL_ENGINEERING = "工程学"
		GOGO_SKILL_TAILORING = "裁缝"
		GOGO_SKILL_RIDING = "骑术"
	
	elseif GetLocale() == "zhTW" then
	
		GoGo_Variables.Localize.Zone.TwistingNether = "扭曲虛空"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "冰凍之海"
		GoGo_Variables.Localize.Zone.AQ40 = "安其拉"
		GoGo_Variables.Localize.Zone.Dalaran = "達拉然"
		GOGO_SZONE_THEUNDERBELLY = "城底區"
		GOGO_SZONE_KRASUSLANDING = "卡薩斯平臺"
		GOGO_SZONE_THEVIOLETCITADEL = "紫羅蘭城塞"
		GoGo_Variables.Localize.Zone.Wintergrasp = "冬握湖"
		GoGo_Variables.Localize.Zone.SholazarBasin = "休拉薩盆地"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "風暴群山"
		GOGO_ZONE_ICECROWN = "寒冰皇冠"
	
		GOGO_SKILL_ENGINEERING = "工程學"
		GOGO_SKILL_TAILORING = "裁縫"
		GOGO_SKILL_RIDING = "騎術"
	
		GOGO_STRING_ENABLEAUTODISMOUNT = "啟用自動解除坐騎"
		GOGO_STRING_DRUIDSINGLECLICK = "單擊後從變身形態轉換為旅行形態"
		GOGO_STRING_SAMEEPICFLYSPEED = "將310%，300%以及280%視為相同速度的坐騎"
		GOGO_STRING_DISABLEUPDATENOTICES = "停用更新通知"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "停用未知的坐騎通知"
		GOGO_STRING_UNKNOWNMOUNTFOUND = "在你的坐騎清單中找到未知的坐騎。請回報它，以便加入到GoGoMount的新版本中。"
		GOGO_STRING_NEWVERSIONFOUND = "可從GoGoMount的更新獲得並可開始使用"
		GOGO_STRING_FAVORITES = "偏好"
		GOGO_STRING_CURRENTZONEFAVORITES = "當前地區的偏好"
		GOGO_STRING_GLOBALFAVORITES = "總體偏好"
		GOGO_STRING_GLOBALPREFERENCES = "總體優先"
	
		BINDING_NAME_GOGOBINDING = "坐騎/解除坐騎"
		BINDING_NAME_GOGOBINDING2 = "坐騎/解除坐騎(無飛行)"
		BINDING_NAME_GOGOBINDING3 = "坐騎/解除有乘客的坐騎"
	
	elseif GetLocale() == "enGB" then
	
		GoGo_Variables.Localize.Zone.TwistingNether = "Twisting Nether"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "The Frozen Sea"
		GoGo_Variables.Localize.Zone.AQ40 = "Ahn'Qiraj"
		GoGo_Variables.Localize.Zone.Dalaran = "Dalaran"
		GOGO_SZONE_THEUNDERBELLY = "The Underbelly"
		GOGO_SZONE_KRASUSLANDING = "Krasus' Landing"
		GOGO_SZONE_THEVIOLETCITADEL = "The Violet Citadel"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Wintergrasp"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Sholazar Basin"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "The Storm Peaks"
		GOGO_ZONE_ICECROWN = "Icecrown"
		GOGO_ZONE_THEOCULUS = "The Oculus"

		GOGO_SKILL_ENGINEERING = "Engineering"
		GOGO_SKILL_TAILORING = "Tailoring"
		GOGO_SKILL_RIDING = "Riding"

	elseif GetLocale() == "ruRU" then

		GoGo_Variables.Localize.Zone.TwistingNether = "Круговерть Пустоты"
		GoGo_Variables.Localize.Zone.TheFrozenSea = "Ледяное море"
		GoGo_Variables.Localize.Zone.AQ40 = "Ан'Кираж" -- or is it  "Храм Ан'Кираж"  ?
		GoGo_Variables.Localize.Zone.Dalaran = "Даларан"
		GOGO_SZONE_THEUNDERBELLY = "Клоака"
		GOGO_SZONE_KRASUSLANDING = "Площадка Краса"
		GOGO_SZONE_THEVIOLETCITADEL = "Аметистовая крепость"
		GoGo_Variables.Localize.Zone.Wintergrasp = "Озеро Ледяных Оков"
		GoGo_Variables.Localize.Zone.SholazarBasin = "Низина Шолазар"
		GOGO_ZONE_ICECROWN = "Ледяная Корона"
		GoGo_Variables.Localize.Zone.TheStormPeaks = "Грозовая Гряда"
		GOGO_ZONE_THEOCULUS = "Окулус"

		GOGO_SKILL_ENGINEERING = "Инженерное дело"
		GOGO_SKILL_TAILORING = "Портняжное дело"
		GOGO_SKILL_RIDING = "Верховая езда"

		GOGO_STRING_UNKNOWNMOUNTFOUND = "Неизвестное средство передвижения было обнаружено в списке ваших средств передвижения. Пожалуйста, сообщите о нём, и, возможно, оно будет добавлено в следующие версии GoGoMount."
		GOGO_STRING_NEWVERSIONFOUND = "Обновление для GoGoMount доступно и уже используется "
		GOGO_STRING_SAMEEPICFLYSPEED = "Считать 310% и 280% одинаковой скоростью"
		GOGO_STRING_DISABLEUPDATENOTICES = "Отключить уведомления об обновлении"
		GOGO_STRING_DISABLEUNKNOWNMOUNTNOTICES = "Отключить уведомления о неизвестных средствах передвижения"
		GOGO_STRING_GLOBALPREFERENCES = "Глобальные предпочтения"
		GOGO_STRING_ENABLEAUTODISMOUNT = "Включить автоматическое спешивание"

		GOGO_TALENT_FERALSWIFTNESS = "Звериная скорость"

	end --if

--end --function
---------
function GoGo_OnLoad(frame)
---------
	frame = frame or LuhUtilitiesMountFrame
	if not frame then
		return
	end
	frame:RegisterEvent("VARIABLES_LOADED")
	frame:RegisterEvent("UPDATE_BINDINGS")
	frame:RegisterEvent("TAXIMAP_OPENED")
	frame:RegisterEvent("CHAT_MSG_ADDON")
	frame:RegisterEvent("COMPANION_LEARNED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("SPELLS_CHANGED")
	frame:SetScript("OnEvent", function(_, event)
		GoGo_OnEvent(event)
	end)
end --function

---------
function GoGo_DoVariablesLoaded()
---------
	if GoGo_Variables.VariablesReady then
		return
	end
	GoGo_Variables.VariablesReady = true

	GoGo_DebugLog = {}
	if not GoGo_Prefs then
		GoGo_Prefs = LS.db.mount
	end --if

	GoGo_Variables.TestVersion = false
	GoGo_Variables.Debug = false
	_, GoGo_Variables.Player.Class = UnitClass("player")
	if (GoGo_Variables.Player.Class == "DRUID") then
		GoGo_Variables.Druid = GoGo_Variables.Druid or {}
		LuhUtilitiesMountFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	elseif (GoGo_Variables.Player.Class == "SHAMAN") then
		GoGo_Variables.Shaman = GoGo_Variables.Shaman or {}
		LuhUtilitiesMountFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	end --if
	GOGO_OUTLANDS = table.concat({GetMapZones(3)}, ":")..":"..GoGo_Variables.Localize.Zone.TwistingNether
	GOGO_NORTHREND = table.concat({GetMapZones(4)}, ":")..":"..GoGo_Variables.Localize.Zone.TheFrozenSea
	LuhUtilitiesMountFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if not GoGo_Prefs.version then
		GoGo_Settings_Default()
	elseif GoGo_Prefs.version ~= LS.VERSION then
		GoGo_Settings_SetUpdates()
	end --if
	GoGo_Panel_Options()
	GoGo_Panel_UpdateViews()
end --function

---------
function GoGo_DoPlayerEnteringWorld()
---------
	GoGo_DoVariablesLoaded()
	GoGo_BuildMountSpellList()
	GoGo_BuildMountItemList()
	GoGo_BuildMountList()
	GoGo_CheckFor310()
	if not InCombatLockdown() then
		GoGo_CheckBindings()
	end --if
	if table.getn(GoGo_Variables.MountList or {}) == 0 then
		GoGo_ScheduleMountRescan()
	end --if
end --function

---------
function GoGo_ScheduleMountRescan()
---------
	if GoGo_Variables.RescanFrame then
		return
	end --if
	local frame = CreateFrame("Frame")
	GoGo_Variables.RescanFrame = frame
	frame.elapsed = 0
	frame.attempts = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < 1 then
			return
		end --if
		self.elapsed = 0
		self.attempts = self.attempts + 1
		GoGo_BuildMountSpellList()
		GoGo_BuildMountItemList()
		GoGo_BuildMountList()
		if table.getn(GoGo_Variables.MountList or {}) > 0 or self.attempts >= 8 then
			self:SetScript("OnUpdate", nil)
			GoGo_Variables.RescanFrame = nil
		end --if
	end)
end --function

---------
function GoGo_OnEvent(event)
---------
	if event == "VARIABLES_LOADED" then
		GoGo_DoVariablesLoaded()
		
	elseif event == "PLAYER_REGEN_DISABLED" then
		for i, button in ipairs({LuhUtilitiesMountButton, LuhUtilitiesMountButton2, LuhUtilitiesMountButton3}) do
			if GoGo_Variables.Player.Class == "SHAMAN" then
				GoGo_FillButton(button, GoGo_InBook(GOGO_SPELLS["SHAMAN"]))
			elseif GoGo_Variables.Player.Class == "DRUID" then
				GoGo_FillButton(button, GoGo_InBook(GOGO_SPELLS["DRUID"]))
			end --if
		end --for
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		SetMapToCurrentZone()
		GoGo_Variables.Player.Zone = GetRealZoneText()
	elseif event == "TAXIMAP_OPENED" then
		GoGo_Dismount()
	elseif event == "UPDATE_BINDINGS" then
		if not InCombatLockdown() then  -- ticket 213
			GoGo_CheckBindings()
		end --if
	elseif event == "UI_ERROR_MESSAGE" then
		if GOGO_ERRORS[arg1] and not IsFlying() then
			GoGo_Dismount()
		end --if
	elseif (event == "PLAYER_ENTERING_WORLD") then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("EVENT: Player Entering World")
		end --if
		GoGo_DoPlayerEnteringWorld()
	elseif (event == "COMPANION_LEARNED") then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("EVENT: Companion Learned")
		end --if
		GoGo_BuildMountSpellList()
		GoGo_BuildMountList()
		GoGo_CheckFor310()
	elseif (event == "SPELLS_CHANGED") then
		GoGo_BuildMountSpellList()
		GoGo_BuildMountList()
--	elseif (event == "BAG_UPDATE") then   -- currently causing a noticable lag when moving bag items around
--		if GoGo_Variables.Debug then
--			GoGo_DebugAddLine("EVENT: Bag Update")
--		end --if
--		GoGo_BuildMountItemList()
--		GoGo_BuildMountList()
	elseif (event == "CHAT_MSG_ADDON") and (arg1 == "GoGoMountVER") and not GoGo_Prefs.DisableUpdateNotice then
		if (arg2 > LS.VERSION) and not GoGo_Variables.UpdateShown then
			GoGo_Variables.UpdateShown = true
			GoGo_Msg(GOGO_STRING_NEWVERSIONFOUND .. arg4)
		end --if
	end --if
end --function

---------
function GoGo_OnSlash(msg)
---------
	if GOGO_COMMANDS[string.lower(msg)] then
		GOGO_COMMANDS[string.lower(msg)]()
	elseif string.find(msg, "spell:%d+") or string.find(msg, "item:%d+") then
		local FItemID = string.gsub(msg,".-\124H([^\124]*)\124h.*", "%1");
		local idtype, itemid = strsplit(":",FItemID);
		GoGo_AddPrefMount(tonumber(itemid))
		GoGo_Msg("pref")
	else
		GoGo_Msg("optiongui")
		GoGo_Msg("auto")
		GoGo_Msg("genericfastflyer")
		GoGo_Msg("updatenotice")
		GoGo_Msg("mountnotice")
		if GoGo_Variables.Player.Class == "DRUID" then GoGo_Msg("druidclickform") end --if
		if GoGo_Variables.Player.Class == "DRUID" then GoGo_Msg("druidflightform") end --if
		GoGo_Msg("pref")
	end --if
end --function

---------
function GoGo_PreClick(button)
---------
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_PreClick: Starts")
		GoGo_DebugAddLine("GoGo_PreClick: Location = " .. GetRealZoneText() .. " - " .. GetZoneText() .. " - " ..GetSubZoneText() .. " - " .. GetMinimapZoneText())
		GoGo_DebugAddLine("GoGo_PreClick: Current unit speed is " .. GetUnitSpeed("player"))
		local level = UnitLevel("player")
		GoGo_DebugAddLine("GoGo_PreClick: We are level " .. level)
		GoGo_DebugAddLine("GoGo_PreClick: We are a " .. GoGo_Variables.Player.Class)
		if GoGo_CanFly() then
			GoGo_DebugAddLine("GoGo_PreClick: We can fly here as per GoGo_CanFly()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We can not fly here as per GoGo_CanFly()")
		end --if
		if IsOutdoors() then
			GoGo_DebugAddLine("GoGo_PreClick: We are outdoors as per IsOutdoors()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not outdoors as per IsOutdoors()")
		end --if
		if IsIndoors() then
			GoGo_DebugAddLine("GoGo_PreClick: We are indoors as per IsIndoors()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not indoors as per IsIndoors()")
		end --if
		if IsFlyableArea() then
			GoGo_DebugAddLine("GoGo_PreClick: We can fly here as per IsFlyableArea()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We can not fly here as per IsFlyableArea()")
		end --if
		if IsFlying() then
			GoGo_DebugAddLine("GoGo_PreClick: We are flying as per IsFlying()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not flying as per IsFlying()")
		end --if
		if IsSwimming() then
			GoGo_DebugAddLine("GoGo_PreClick: We are swimming as per IsSwimming()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not swimming as per IsSwimming()")
		end --if
		if IsFalling() then
			GoGo_DebugAddLine("GoGo_PreClick: We are falling as per IsFalling()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not falling as per IsFalling()")
		end --if
		if GoGo_IsMoving() then
			GoGo_DebugAddLine("GoGo_PreClick: We are moving as per GoGo_IsMoving()")
		else
			GoGo_DebugAddLine("GoGo_PreClick: We are not moving as per GoGo_IsMoving()")
		end --if
		local posX, posY = GetPlayerMapPosition("Player")
		GoGo_DebugAddLine("GoGo_PreClick: Player location: X = ".. posX .. ", Y = " .. posY)
	end --if

	if not InCombatLockdown() then
		GoGo_FillButton(button)
	end --if

	if IsMounted() or CanExitVehicle() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_PreClick: Player is mounted and is being dismounted.")
		end --if
		GoGo_Dismount()
	elseif GoGo_Variables.Player.Class == "DRUID" and GoGo_IsShifted() and not InCombatLockdown() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_PreClick: Player is a druid, is shifted and not in combat.")
		end --if
		GoGo_Dismount(button)
	elseif GoGo_Variables.Player.Class == "SHAMAN" and UnitBuff("player", GoGo_Variables.Localize.GhostWolf) then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_PreClick: Player is a shaman and is in wolf form.")
		end --if
		GoGo_Dismount()
	elseif not InCombatLockdown() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_PreClick: Player not in combat, button pressed, looking for a mount.")
		end --if
		GoGo_FillButton(button, GoGo_GetMount())
	end --if
	
	if not GoGo_Variables.TestVersion then
		if ( IsInGuild() ) then
			SendAddonMessage("GoGoMountVER", LS.VERSION, "GUILD")
		end --if
--			SendAddonMessage("GoGoMountVER", GetAddOnMetadata("GoGoMount", "Version"), "BATTLEGROUND")
--			SendAddonMessage("GoGoMountVER", GetAddOnMetadata("GoGoMount", "Version"), "RAID")
	end --if
	GoGo_Variables.Debug = false
end --function

---------
function GoGo_GetMount()
---------

	local selectedmount = GoGo_ChooseMount()

--	if (GoGo_Variables.Player.Class == "PALADIN") and GoGo_Prefs.PaliUseCrusader and GoGo_InBook(GoGo_Variables.Localize.CrusaderAura) then
--		local modifier = GetSpellInfo(GoGo_Variables.Localize.CrusaderAura)
--		selectedmount = selectedmount .. "\n /stopcasting;\n /cast " .. modifier
--	end --if
	
	return selectedmount
	
end --function

---------
function GoGo_ChooseMount()
---------
	if (GoGo_Variables.Player.Class == "DRUID") then
		GoGo_Variables.Druid = GoGo_Variables.Druid or {}
		GoGo_Variables.Druid.FeralSwiftness, _ = GoGo_GetTalentInfo(GOGO_TALENT_FERALSWIFTNESS)
		if IsIndoors() then
			if IsSwimming() then
				return GoGo_InBook(GoGo_Variables.Localize.AquaForm)
			elseif GoGo_Variables.Druid.FeralSwiftness > 0 then
				return GoGo_InBook(GoGo_Variables.Localize.CatForm)
			end --if
			return
		end --if
		if (IsSwimming() or IsFalling() or GoGo_IsMoving()) then
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_ChooseMount: We are a druid and we're falling, swimming or moving.  Changing shape form.")
			end --if
			return GoGo_InBook(GOGO_SPELLS["DRUID"])
		end --if
	elseif (GoGo_Variables.Player.Class == "SHAMAN") and GoGo_IsMoving() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: We are a shaman and we're moving.  Changing shape form.")
		end --if
		GoGo_Variables.Shaman = GoGo_Variables.Shaman or {}
		GoGo_Variables.Shaman.ImprovedGhostWolf, _ = GoGo_GetTalentInfo(GOGO_TALENT_IMPROVEDGHOSTWOLF)
		if (GoGo_Variables.Shaman.ImprovedGhostWolf == 2) then return GoGo_InBook(GOGO_SPELLS["SHAMAN"]) end --if
	elseif (GoGo_Variables.Player.Class == "HUNTER") and GoGo_IsMoving() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: We are a hunter and we're moving.  Checking for aspects.")
		end --if
--		if GoGo_InBook(GoGo_Variables.Localize.AspectPack) then
--			return GoGo_InBook(GoGo_Variables.Localize.AspectPack)
		if GoGo_InBook(GoGo_Variables.Localize.AspectCheetah) then
			return GoGo_InBook(GoGo_Variables.Localize.AspectCheetah)
		end --if
	end --if

	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_ChooseMount: Passed Druid / Shaman forms - nothing selected.")
	end --if

	local mounts = {}
	local GoGo_FilteredMounts = {}
	GoGo_Variables.Player.Zone = GetRealZoneText()
	GoGo_Variables.EngineeringLevel = GoGo_GetSkillLevel(GOGO_SKILL_ENGINEERING) or 0
	GoGo_Variables.TailoringLevel = GoGo_GetSkillLevel(GOGO_SKILL_TAILORING) or 0
	GoGo_Variables.RidingLevel = GoGo_GetSkillLevel(GOGO_SKILL_RIDING) or 0
	
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_ChooseMount: " .. GOGO_SKILL_ENGINEERING .. " = "..GoGo_Variables.EngineeringLevel)
		GoGo_DebugAddLine("GoGo_ChooseMount: " .. GOGO_SKILL_TAILORING .. " = "..GoGo_Variables.TailoringLevel)
		GoGo_DebugAddLine("GoGo_ChooseMount: " .. GOGO_SKILL_RIDING .. " = "..GoGo_Variables.RidingLevel)
	end --if

	if (table.getn(mounts) == 0) then
		if GoGo_Prefs[GoGo_Variables.Player.Zone] then
			GoGo_FilteredMounts = GoGo_Prefs[GoGo_Variables.Player.Zone]
			GoGo_DisableUnknownMountNotice = true
		end --if
	end --if
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_ChooseMount: Checked for zone favorites.")
	end --if

	if (table.getn(mounts) == 0) and not GoGo_FilteredMounts or (table.getn(GoGo_FilteredMounts) == 0) then
		if GoGo_Prefs.GlobalPrefMounts then
			GoGo_FilteredMounts = GoGo_Prefs.GlobalPrefMounts
			GoGo_DisableUnknownMountNotice = true
		end --if
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Checked for global favorites.")
		end --if
	end --if

	if (table.getn(mounts) == 0) and not GoGo_FilteredMounts or (table.getn(GoGo_FilteredMounts) == 0) then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Checking for spell and item mounts.")
		end --if
		-- Not updating bag items on bag changes right now so scan and update list
		GoGo_BuildMountItemList()
		GoGo_BuildMountList()
		GoGo_FilteredMounts = GoGo_Variables.MountList
		if not GoGo_FilteredMounts or (table.getn(GoGo_FilteredMounts) == 0) then
			if GoGo_Variables.Player.Class == "SHAMAN" then
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_ChooseMount: No mounts found. Forcing shaman shape form.")
				end --if
				return GoGo_InBook(GOGO_SPELLS["SHAMAN"])
			elseif GoGo_Variables.Player.Class == "DRUID" then
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_ChooseMount: No mounts found. Forcing druid shape form.")
				end --if
				return GoGo_InBook(GOGO_SPELLS["DRUID"])
			else
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_ChooseMount: No mounts found.  Giving up the search.")
				end --if
				return nil
			end --if
		end --if
	end --if
	
	local GoGo_TempMounts = {}
	if GoGo_Variables.EngineeringLevel <= 299 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 45)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 46)
	elseif GoGo_Variables.EngineeringLevel >= 300 and GoGo_Variables.EngineeringLevel <= 374 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 46)
	elseif GoGo_Variables.EngineeringLevel >= 375 then
		-- filter nothing
	else
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 45)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 46)
	end --if
	if GoGo_Variables.TailoringLevel <= 299 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 49)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 48)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 47)
	elseif GoGo_Variables.TailoringLevel >= 300 and GoGo_Variables.TailoringLevel <= 424 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 49)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 47)
	elseif GoGo_Variables.TailoringLevel >= 425 and GoGo_Variables.TailoringLevel <= 449 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 47)
	elseif GoGo_Variables.TailoringLevel >= 450 then
		-- filter nothing
	else
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 49)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 48)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 47)
	end --if

	if IsSwimming() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Forcing ground mounts because we're swimming.")
		end --if
		GoGo_Variables.SkipFlyingMount = true
	else
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 53)
	end --if
	
	if GoGo_Variables.Player.Zone ~= GoGo_Variables.Localize.Zone.AQ40 then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Removing AQ40 mounts since we are not in AQ40.")
		end --if
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 50)
	end --if

	if GoGo_Variables.SelectPassengerMount then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Filtering out all mounts except passenger mounts since passenger mount only was requested.")
		end --if
		GoGo_FilteredMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 2) or {}
	end --if

	if (table.getn(mounts) == 0) and IsSwimming() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Looking for water speed increase mounts since we're in water.")
		end --if
		mounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 5) or {}
	end --if
	
	if (table.getn(mounts) == 0) and GoGo_CanFly() and not GoGo_Variables.SkipFlyingMount then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Looking for flying mounts since we past flight checks.")
		end --if
		if GoGo_Variables.RidingLevel <= 224 then
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 36)
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 35)
		elseif GoGo_Variables.RidingLevel >= 225 and GoGo_Variables.RidingLevel <= 299 then
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 35)
		elseif GoGo_Variables.RidingLevel >= 300 then
			-- filter nothing
		else
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 36)
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 35)
		end --if

		-- Druid stuff... 
		-- Use flight forms if preferred
		if GoGo_Variables.Player.Class == "DRUID" and (GoGo_InBook(GoGo_Variables.Localize.FastFlightForm) or GoGo_InBook(GoGo_Variables.Localize.FlightForm)) and GoGo_Prefs.DruidFlightForm then
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_ChooseMount: Druid with preferred flight forms option enabled.  Using flight form.")
			end --if
			return GoGo_InBook(GOGO_SPELLS["DRUID"])
		end --if
	
		if (table.getn(mounts) == 0) then
			GoGo_TempMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 9)
			mounts = GoGo_FilterMountsIn(GoGo_TempMounts, 24)
		end --if
		if GoGo_Prefs.genericfastflyer then
			local GoGo_TempMountsA = GoGo_FilterMountsIn(GoGo_TempMounts, 23)
			if GoGo_Variables.RidingLevel <= 299 then
				GoGo_TempMountsA = GoGo_FilterMountsOut(GoGo_TempMountsA, 29)
			end --if
			if GoGo_TempMountsA then
				for counter = 1, table.getn(GoGo_TempMountsA) do
					table.insert(mounts, GoGo_TempMountsA[counter])
				end --for
			end --if
			local GoGo_TempMountsA = GoGo_FilterMountsIn(GoGo_TempMounts, 26)
			if GoGo_TempMountsA then
				for counter = 1, table.getn(GoGo_TempMountsA) do
					table.insert(mounts, GoGo_TempMountsA[counter])
				end --for
			end --if
		end --if
		if (table.getn(mounts) == 0) then
			GoGo_TempMountsA = GoGo_FilterMountsIn(GoGo_TempMounts, 23)
			if GoGo_Variables.RidingLevel <= 299 then
				mounts = GoGo_FilterMountsOut(GoGo_TempMountsA, 29)
			else
				mounts = GoGo_TempMountsA
			end --if
		end --if

		-- no epic flyers found - add druid swift flight if available
		if (table.getn(mounts) == 0 and (GoGo_Variables.Player.Class == "Druid") and (GoGo_InBook(GoGo_Variables.Localize.FastFlightForm))) then
			table.insert(mounts, GoGo_Variables.Localize.FastFlightForm)
		end --if

		if (table.getn(mounts) == 0) then
			GoGo_TempMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 9)
			mounts = GoGo_FilterMountsIn(GoGo_TempMounts, 22)
		end --if

		-- no slow flying mounts found - add druid flight if available
		if (table.getn(mounts) == 0 and (GoGo_Variables.Player.Class == "Druid") and (GoGo_InBook(GoGo_Variables.Localize.FlightForm))) then
			table.insert(mounts, GoGo_Variables.Localize.FlightForm)
		end --if
	end --if
	
	if (table.getn(GoGo_FilteredMounts) >= 1) then
		--GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 1)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 36)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 35)
	end --if

	if (table.getn(mounts) == 0) and (table.getn(GoGo_FilteredMounts) >= 1) then  -- no flying mounts selected yet - try to use loaned mounts
		GoGo_TempMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 52) or {}
		if (table.getn(GoGo_TempMounts) >= 1) and (GoGo_Variables.Player.Zone == GoGo_Variables.Localize.Zone.SholazarBasin or GoGo_Variables.Player.Zone == GoGo_Variables.Localize.Zone.TheStormPeaks or GoGo_Variables.Player.Zone == GOGO_ZONE_ICECROWN) then
			mounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 52)
		end --if
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 52)
	end --if
	
	-- Set the oculus mounts as the only mounts available if we're in the oculus, not skiping flying and have them in inventory
	if (table.getn(mounts) == 0) and (table.getn(GoGo_FilteredMounts) >= 1) and (GoGo_Variables.Player.Zone == GOGO_ZONE_THEOCULUS) and not GoGo_Variables.SkipFlyingMount then
		GoGo_TempMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 54) or {}
		if (table.getn(GoGo_TempMounts) >= 1) then
			mounts = GoGo_TempMounts
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_ChooseMount: In the Oculus, Oculus only mount found, using.")
			end --if
		else
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_ChooseMount: In the Oculus, no oculus mount found in inventory.")
			end --if
		end --if
	else
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 54)
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Not in Oculus or forced ground mount only.")
		end --if
	end --if
	
	-- Select ground mounts
	if (table.getn(mounts) == 0) and GoGo_CanRide() then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_ChooseMount: Looking for ground mounts since we can't fly.")
		end --if
		if GoGo_Variables.RidingLevel <= 74 then
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 37)
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 38)
		elseif GoGo_Variables.RidingLevel >= 75 and GoGo_Variables.RidingLevel <= 149 then
			GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 37)
		end --if
		GoGo_TempMounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 21)
		if GoGo_Variables.RidingLevel <= 149 then
			GoGo_TempMounts = GoGo_FilterMountsOut(GoGo_TempMounts, 29)
		end --if
		if GoGo_Variables.RidingLevel <= 225 and GoGo_CanFly() then
			mounts = GoGo_FilterMountsOut(GoGo_TempMounts, 3)
		else
			mounts = GoGo_TempMounts
		end --if
		if (table.getn(mounts) == 0) then
			mounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 20)
		end --if
		if (table.getn(mounts) == 0) then
			mounts = GoGo_FilterMountsIn(GoGo_FilteredMounts, 25)
		end --if
	end --if
	
	if table.getn(GoGo_FilteredMounts) >= 1 then
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 37)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 38)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 21)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 20)
		GoGo_FilteredMounts = GoGo_FilterMountsOut(GoGo_FilteredMounts, 25)
	end --if
	
	if (table.getn(mounts) == 0) then
		if (GoGo_Variables.Player.Class == "SHAMAN") and (GoGo_InBook(GoGo_Variables.Localize.GhostWolf)) then
			table.insert(mounts, GoGo_Variables.Localize.GhostWolf)
		end --if
	end --if

	if (table.getn(mounts) >= 1) then
		if GoGo_Variables.Debug then
			for a = 1, table.getn(mounts) do
				GoGo_DebugAddLine("GoGo_ChooseMount: Found mount " .. mounts[a] .. " - included in random pick.")
			end --for
		end --if
		selected = mounts[math.random(table.getn(mounts))]
		if type(selected) == "string" then
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_ChooseMount: Selected string " .. selected)
			end --if
			return selected
		else
			selected = GoGo_GetIDName(selected)
			return selected
		end --if
	end --if
end --function

---------
function GoGo_FilterMountsOut(PlayerMounts, FilterID)
---------
	local GoGo_FilteringMounts = {}
	if table.getn(PlayerMounts) == 0 then
		return GoGo_FilteringMounts
	end --if
	for a = 1, table.getn(PlayerMounts) do
		local MountID = PlayerMounts[a]
		for DBMountID, DBMountData in pairs(LuhUtilities.MountDB) do
			if (DBMountID == MountID) and not DBMountData[FilterID] then
				table.insert(GoGo_FilteringMounts, MountID)
			elseif not LuhUtilities.MountDB[MountID] then
				GoGo_Prefs.UnknownMounts[MountID] = true
				if not GoGo_Prefs.DisableMountNotice and not GoGo_DisableUnknownMountNotice then
					GoGo_DisableUnknownMountNotice = true
					GoGo_Msg("UnknownMount")
				end --if
			end --if
		end --for
	end --for
	return GoGo_FilteringMounts
end --function

---------
function GoGo_FilterMountsIn(PlayerMounts, FilterID)
---------
	local GoGo_FilteringMounts = {}
	if table.getn(PlayerMounts) == 0 then
		return GoGo_FilteringMounts
	end --if
	for a = 1, table.getn(PlayerMounts) do
		local MountID = PlayerMounts[a]
		for DBMountID, DBMountData in pairs(LuhUtilities.MountDB) do
			if (DBMountID == MountID) and DBMountData[FilterID] then
				table.insert(GoGo_FilteringMounts, MountID)
			elseif not LuhUtilities.MountDB[MountID] then
				GoGo_Prefs.UnknownMounts[MountID] = true
				if not GoGo_Prefs.DisableMountNotice and not GoGo_DisableUnknownMountNotice then
					GoGo_DisableUnknownMountNotice = true
					GoGo_Msg("UnknownMount")
				end --if
			end --if
		end --for
	end --for
	return GoGo_FilteringMounts
end --function

---------
function GoGo_Dismount(button)
---------
	if IsMounted() then
		Dismount()
	elseif CanExitVehicle() then	
		VehicleExit()
	elseif GoGo_Variables.Player.Class == "DRUID" then
		if GoGo_IsShifted() and button then
			if GoGo_Prefs.DruidClickForm and not IsFlying() then
				GoGo_FillButton(button, GoGo_GetMount())
			else
--				CancelUnitBuff("player", GoGo_IsShifted())  -- protected by blizzard now
				GoGo_FillButton(button, GoGo_IsShifted())
			end --if
		end --if
	elseif GoGo_Variables.Player.Class == "SHAMAN" and UnitBuff("player", GoGo_InBook(GoGo_Variables.Localize.GhostWolf)) then
		CancelUnitBuff("player", GoGo_InBook(GoGo_Variables.Localize.GhostWolf))
	else
		return nil
	end --if
	return true
end --function

---------
function GoGo_InCompanions(item)
---------
	for slot = 1, GetNumCompanions("MOUNT") do
		local spellID = GoGo_GetCompanionSpellId("MOUNT", slot)
		if spellID and string.find(item, spellID) then
			if GoGo_Variables.Debug then 
				GoGo_DebugAddLine("GoGo_InCompanions: Found mount name  " .. GetSpellInfo(spellID) .. " in mount list.")
			end --if
			return GetSpellInfo(spellID)
		end --if
	end --for
end --function

---------
function GoGo_GetCompanionSpellId(companionType, slot)
---------
	if not GetCompanionInfo then
		return nil
	end --if
	local r1, r2, r3, r4, r5 = GetCompanionInfo(companionType, slot)
	for _, value in ipairs({r2, r3, r5, r1}) do
		if type(value) == "number" and value > 100 then
			return value
		end --if
	end --for
	return nil
end --function

---------
function GoGo_AddMountSpellId(spellId)
---------
	if not spellId then
		return
	end --if
	for a = 1, table.getn(GoGo_Variables.MountSpellList) do
		if GoGo_Variables.MountSpellList[a] == spellId then
			return
		end --if
	end --for
	table.insert(GoGo_Variables.MountSpellList, spellId)
end --function

---------
function GoGo_SpellNameLooksLikeMount(name)
---------
	if not name then
		return false
	end --if
	local patterns = {
		"Mount", "Steed", "Horse", "Charger", "Warhorse", "Kodo", "Ram", "Raptor",
		"Strider", "Mechanostrider", "Mechano%-strider", "Felsteed", "Dreadsteed",
		"Wind Rider", "Windrider", "Gryphon", "Wyvern", "Drake", "Proto%-Drake",
		"Hawkstrider", "Elekk", "Talbuk", "Mammoth", "Tiger", "Bike", "Broom",
		"Turtle", "Polar Bear", "Reindeer", "Runner", "Talbuk", "Rhino", "Stallion",
		"Palomino", "Pinto", "Skeletal", "Venomhide", "Mule", "Saber", "Sabre",
	}
	for a = 1, table.getn(patterns) do
		if string.find(name, patterns[a]) then
			return true
		end --if
	end --for
	return false
end --function

---------
function GoGo_SpellTooltipLooksLikeMount(spellName)
---------
	if not spellName or not LuhUtilitiesScanTooltip then
		return false
	end --if
	local link = GetSpellLink(spellName)
	if not link then
		return false
	end --if
	LuhUtilitiesScanTooltip:ClearLines()
	LuhUtilitiesScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	LuhUtilitiesScanTooltip:SetHyperlink(link)
	for i = 1, LuhUtilitiesScanTooltip:NumLines() do
		local left = _G["LuhUtilitiesScanTooltipTextLeft" .. i]
		if left then
			local text = left:GetText() or ""
			if string.find(text, "Mount") or string.find(text, "mount") or string.find(text, "Summons a") then
				return true
			end --if
		end --if
	end --for
	return false
end --function

---------
function GoGo_BuildMountSpellListFromCompanions()
---------
	if not GetNumCompanions then
		return false
	end --if
	local found = false
	local types = {"MOUNT", "mount"}
	for t = 1, table.getn(types) do
		local companionType = types[t]
		local count = GetNumCompanions(companionType) or 0
		for slot = 1, count do
			local spellID = GoGo_GetCompanionSpellId(companionType, slot)
			if spellID then
				GoGo_AddMountSpellId(spellID)
				found = true
			end --if
		end --for
	end --for
	return found
end --function

---------
function GoGo_BuildMountSpellListFromMountJournal()
---------
	if not C_MountJournal or not C_MountJournal.GetMountIDs or not C_MountJournal.GetMountInfoByID then
		return false
	end --if
	local found = false
	local mountIDs = C_MountJournal.GetMountIDs()
	if not mountIDs then
		return false
	end --if
	for i = 1, #mountIDs do
		local mountID = mountIDs[i]
		local _, spellID, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		if isCollected and spellID then
			GoGo_AddMountSpellId(spellID)
			found = true
		end --if
	end --for
	return found
end --function

---------
function GoGo_BuildMountSpellListFromSpellbook()
---------
	local found = false
	for mountId, _ in pairs(LuhUtilities.MountDB) do
		if type(mountId) == "number" and GoGo_InBook(mountId) then
			GoGo_AddMountSpellId(mountId)
			found = true
		end --if
	end --for
	local slot = 1
	while GetSpellName(slot, "spell") do
		local name = GetSpellName(slot, "spell")
		local link = GetSpellLink(name)
		if link then
			local _, _, spellId = string.find(link, "spell:(%d+)")
			spellId = tonumber(spellId)
			if spellId and (GoGo_SpellNameLooksLikeMount(name) or GoGo_SpellTooltipLooksLikeMount(name)) then
				GoGo_AddMountSpellId(spellId)
				found = true
			end --if
		end --if
		slot = slot + 1
	end --while
	return found
end --function

---------
function GoGo_BuildMountSpellList()
---------
	GoGo_Variables.MountSpellList = {}
	GoGo_BuildMountSpellListFromCompanions()
	if table.getn(GoGo_Variables.MountSpellList) == 0 then
		GoGo_BuildMountSpellListFromMountJournal()
	end --if
	if table.getn(GoGo_Variables.MountSpellList) == 0 then
		GoGo_BuildMountSpellListFromSpellbook()
	end --if
	return GoGo_Variables.MountSpellList
end  -- function

---------
function GoGo_BuildMountList()
---------
	GoGo_Variables.MountList = {}
	if (table.getn(GoGo_Variables.MountSpellList) > 0) then
		for a=1, table.getn(GoGo_Variables.MountSpellList) do
			table.insert(GoGo_Variables.MountList, GoGo_Variables.MountSpellList[a])
		end --for
	end --if
	
	if (table.getn(GoGo_Variables.MountItemList) > 0) then
		for a=1, table.getn(GoGo_Variables.MountItemList) do
			table.insert(GoGo_Variables.MountList, GoGo_Variables.MountItemList[a])
		end --for
	end --if

	return GoGo_Variables.MountList
end  --function

---------
function GoGo_BuildMountItemList()
---------
	GoGo_Variables.MountItemList = {}
	
	for a = 1, table.getn(LuhUtilities.MountItems) do
		local MountID = LuhUtilities.MountItems[a]
		if GoGo_InBags(MountID) then
			if GoGo_Variables.Debug then 
				GoGo_DebugAddLine("GoGo_BuildMountItemList: Found mount item ID " .. MountID .. " in a bag and added to known mount list.")
			end --if
			table.insert(GoGo_Variables.MountItemList, MountID)
		end --if
	end --for
	return GoGo_Variables.MountItemList
end --function

---------
function GoGo_InBags(item)
---------
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_InBags: Searching for " .. item)
	end --if

	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link then
				local _, itemid, _ = strsplit(":",link,3)
				if tonumber(itemid) == item then
					if GoGo_Variables.Debug then 
						GoGo_DebugAddLine("GoGo_InBags: Found item ID " .. item .. " in bag " .. (bag+1) .. ", at slot " .. slot .. " and added to known mount list.")
					end --if
					return GetItemInfo(link)
				end --if
			end --if
		end --for
	end --for
end --function

---------
function GoGo_InBook(spell)
---------
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_InBook: Searching for type " .. type(spell))
	end --if
	if type(spell) == "function" then
		return spell()
	else
		if type(spell) == "string" then
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_InBook: Searching for " .. spell)
			end --if
			local slot = 1
			while GetSpellName(slot, "spell") do
				local name = GetSpellName(slot, "spell")
				if name == spell then
					return spell
				end --if
				slot = slot + 1
			end --while
		elseif type(spell) == "number" then
			local spellname = GetSpellInfo(spell)
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_InBook: Searching for spell ID " .. spell)
			end --if
			local slot = 1
			while GetSpellName(slot, "spell") do
				local name = GetSpellName(slot, "spell")
				if name == spellname then
					return name
				end --if
				slot = slot + 1
			end --while
			-- blah
		end --if
	end --if
end --function

---------
function GoGo_IsShifted()
---------
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_IsShifted:  GoGo_IsShifted starting")
	end --if
	for i = 1, GetNumShapeshiftForms() do
		local _, name, active = GetShapeshiftFormInfo(i)
		if active then
			if GoGo_Variables.Debug then
				GoGo_DebugAddLine("GoGo_IsShifted: Found " .. name)
			end --if
			return name
		end
	end --for
end --function

---------
function GoGo_InOutlands()
---------
	if not GOGO_OUTLANDS or not GoGo_Variables.Player.Zone then
		return false
	end --if
	if string.find(GOGO_OUTLANDS, GoGo_Variables.Player.Zone, 1, true) then
		return true
	end --if
end --function

function GoGo_InNorthrend()
---------
	if not GOGO_NORTHREND or not GoGo_Variables.Player.Zone then
		return false
	end --if
	if string.find(GOGO_NORTHREND, GoGo_Variables.Player.Zone, 1, true) then
		return true
	end --if
end --function

---------
function GoGo_AddPrefMount(spell)
---------
	if GoGo_Variables.Debug then 
		GoGo_DebugAddLine("GoGo_AddPrefMount: Preference " .. spell)
	end --if

	if not GoGo_Prefs.GlobalPrefMount then
		GoGo_Variables.Player.Zone = GetRealZoneText()
		if not GoGo_Prefs[GoGo_Variables.Player.Zone] then GoGo_Prefs[GoGo_Variables.Player.Zone] = {} end
		table.insert(GoGo_Prefs[GoGo_Variables.Player.Zone], spell)
		if table.getn(GoGo_Prefs[GoGo_Variables.Player.Zone]) > 1 then
			local i = 2
			repeat
				if GoGo_Prefs[GoGo_Variables.Player.Zone][i] == GoGo_Prefs[GoGo_Variables.Player.Zone][i - 1] then
					table.remove(GoGo_Prefs[GoGo_Variables.Player.Zone], i)
				else
					i = i + 1
				end --if
			until i > table.getn(GoGo_Prefs[GoGo_Variables.Player.Zone])
		end --if
	else
		if not GoGo_Prefs.GlobalPrefMounts then GoGo_Prefs.GlobalPrefMounts = {} end
		table.insert(GoGo_Prefs.GlobalPrefMounts, spell)
		if table.getn(GoGo_Prefs.GlobalPrefMounts) > 1 then
			local i = 2
			repeat
				if GoGo_Prefs.GlobalPrefMounts[i] == GoGo_Prefs.GlobalPrefMounts[i - 1] then
					table.remove(GoGo_Prefs.GlobalPrefMounts, i)
				else
					i = i + 1
				end --if
			until i > table.getn(GoGo_Prefs.GlobalPrefMounts)
		end --if
	end --if
end --function

---------
function GoGo_GetIDName(itemid)
---------
	local tempname = ""
	local ItemName = ""
	if type(itemid) == "number" then
		local GoGo_TempMount = {}
		table.insert(GoGo_TempMount, itemid)
		if (table.getn(GoGo_FilterMountsIn(GoGo_TempMount, 4)) == 1) then
			return GetItemInfo(itemid) or "Unknown Mount"
		else
			return GetSpellInfo(itemid) or "Unknown Mount"
		end --if
	elseif type(itemid) == "table" then
		for a=1, table.getn(itemid) do
			tempname = itemid[a]
			local GoGo_TempTable = {}
			table.insert(GoGo_TempTable, tempname)
			if (table.getn(GoGo_FilterMountsIn(GoGo_TempTable, 4)) == 1) then
--				tempname = GetItemInfo(tempname)
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_GetIDName: GetItemID for " .. tempname .. GetItemInfo(tempname))
				end --if
				ItemName = ItemName .. (GetItemInfo(tempname) or "Unknown Mount") .. ", "
			else
--				tempname = GetSpellInfo(tempname)
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_GetIDName: GetSpellID for " .. tempname .. GetSpellInfo(tempname))
				end --if
				ItemName = ItemName .. (GetSpellInfo(tempname) or "Unknown Mount") .. ", "
			end --if
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_GetIDName: Itemname string is " .. ItemName)
				end --if
		end --for
		return ItemName
	end --if
end --function

---------
function GoGo_GetTalentInfo(talentname)
---------
	if GoGo_Variables.Debug then 
		GoGo_DebugAddLine("GoGo_GetTalentInfo: Searching talent tree for " .. talentname)
	end --if
	local numTabs = GetNumTalentTabs()
	for tab=1, numTabs do
		local numTalents = GetNumTalents(tab)
		for talent=1, numTalents do
			local name, _, _, _, rank, maxrank = GetTalentInfo(tab,talent)
			if (talentname == name) then
				if GoGo_Variables.Debug then 
					GoGo_DebugAddLine("GoGo_GetTalentInfo: Found " .. talentname .. " with rank " .. rank)
				end --if
				return rank, maxrank
			end --if
		end --for
	end --for
	return 0,0
end --function

---------
function GoGo_FillButton(button, mount)
---------
	if mount then
		local macro = LS:BuildMountMacroText(mount)
		if not macro then
			if type(mount) == "string" and (mount:find("%[") or mount:find(";")) then
				macro = "/cast " .. mount
			else
				macro = "/use " .. mount
			end
		end
		button:SetAttribute("macrotext", macro)
	else
		button:SetAttribute("macrotext", nil)
	end --if
end --function

---------
function GoGo_CheckBindings()
---------
	local bindings = {
		{"LUHMOUNT", LuhUtilitiesMountButton},
		{"LUHMOUNT_GROUND", LuhUtilitiesMountButton2},
		{"LUHMOUNT_PASSENGER", LuhUtilitiesMountButton3},
	}
	for i = 1, table.getn(bindings) do
		local binding = bindings[i][1]
		local button = bindings[i][2]
		if button then
			ClearOverrideBindings(button)
			local key1, key2 = GetBindingKey(binding)
			if key1 then
				SetOverrideBindingClick(button, true, key1, button:GetName())
			end --if
			if key2 then
				SetOverrideBindingClick(button, true, key2, button:GetName())
			end --if
		end --if
	end --for
end --function

---------
function GoGo_CanFly()
---------
	GoGo_Variables.Player.Zone = GetRealZoneText()
	GoGo_Variables.Player.SubZone = GetSubZoneText()

	local level = UnitLevel("player")
--	if (level <= 69) and not (GoGo_Variables.Player.Class == "DRUID") then
--		return false
--	elseif (GoGo_Variables.Player.Class == "DRUID" and level <= 67) then
--		return false
--	end --if
	if (level < 60) then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_CanFly: Failed - Player under level 60")
		end --if
		return false
	end --if
	
	if GoGo_InOutlands() then
		-- we can fly here
	elseif (GoGo_InNorthrend() and (GoGo_InBook(GoGo_Variables.Localize.ColdWeatherFlying))) then
		if GoGo_Variables.Player.Zone == GoGo_Variables.Localize.Zone.Dalaran then
			if (GoGo_Variables.Player.SubZone == GOGO_SZONE_KRASUSLANDING) then
				if not IsFlyableArea() then
					if GoGo_Variables.Debug then
						GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GOGO_SZONE_KRASUSLANDING .. " and not in flyable area.")
					end --if
					return false
				end --if
			elseif (GoGo_Variables.Player.SubZone == GOGO_SZONE_THEVIOLETCITADEL) then
				if not IsOutdoors() then
					if GoGo_Variables.Debug then
						GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GOGO_SZONE_THEVIOLETCITADEL .. " and not outdoors area.")
					end --if
					return false
				end --if
--				if not GoGo_CheckCoOrds("Dalaran", "VioletCitadel") then
--					return false
--				end --if
				if not IsFlyableArea() then
					if GoGo_Variables.Debug then
						GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GOGO_SZONE_THEVIOLETCITADEL .. " and not in flyable area.")
					end --if
					return false
				end --if
			elseif (GoGo_Variables.Player.SubZone == GOGO_SZONE_THEUNDERBELLY) then
--				if not GoGo_CheckCoOrds("Dalaran", "Underbelly") then
--					return false
--				end --if
				if not IsFlyableArea() then
					if GoGo_Variables.Debug then
						GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GOGO_SZONE_THEUNDERBELLY .. " and not in flyable area.")
					end --if
					return false
				end --if
			elseif (GoGo_Variables.Player.SubZone == GoGo_Variables.Localize.Zone.Dalaran) then
--				if not GoGo_CheckCoOrds("Dalaran", "Dalaran") then
--					return false
--				end --if
				if not IsFlyableArea() then
					if GoGo_Variables.Debug then
						GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GoGo_Variables.Localize.Zone.Dalaran .. " and not outdoors area.")
					end --if
					return false
				end --if
			else
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in " .. GoGo_Variables.Localize.Zone.Dalaran .. " and not in known flyable subzone.")
				end --if
				return false
			end --if
		end --if

		if GoGo_Variables.Player.Zone == GoGo_Variables.Localize.Zone.Wintergrasp then
			if GetWintergraspWaitTime() then
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_CanFly: Player in Wintergrasp and battle ground is not active.")
				end --if
				-- timer ticking to start wg.. we can mount
			else
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_CanFly: Failed - Player in Wintergrasp and battle ground is active.")
				end --if
				-- we should be in battle.. can't mount
				return false
			end --if
		end --if
	else
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_CanFly: Failed - Player does not meet any flyable conditions.")
		end --if
		return false  -- we can't fly anywhere else
	end --if
	
	return true
end --function

---------
function GoGo_CanRide()
---------
	local level = UnitLevel("player")
	if level >= 20 then
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_CanRide: Passed - Player is over level 20.")
		end --if
		return true
	end --if
end --function

---------
function GoGo_CheckFor310()  -- checks to see if any existing 310% mounts exist to increase the speed of [6] mounts
---------
	local loop
	local MountID
	if GoGo_Variables.Debug then
		GoGo_DebugAddLine("GoGo_CheckFor310: Function executed.")
	end --if

	local Find310Mounts = GoGo_FilterMountsIn(GoGo_Variables.MountList,24)
	for loop=1, table.getn(Find310Mounts) do
		MountID = Find310Mounts[loop]
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_CheckFor310: Mount ID " .. MountID .. " found as 310% flying.")
		end --if
	end --for
	if (table.getn(Find310Mounts) > 0) then
		Find310Mounts = GoGo_FilterMountsIn(GoGo_Variables.MountList,6)
		if table.getn(Find310Mounts) then
			for loop=1, table.getn(Find310Mounts) do
				MountID = Find310Mounts[loop]
				LuhUtilities.MountDB[MountID][24] = true
				if GoGo_Variables.Debug then
					GoGo_DebugAddLine("GoGo_CheckFor310: Mount ID " .. MountID .. " added as 310% flying.")
				end --if

			end --for
		end --if
	end --if
end --function

---------
function GoGo_IsMoving()
---------
    if GetUnitSpeed("player") ~= 0 then
        return true
    else
        return false
    end --if
end --function

---------
function GoGo_GetSkillLevel(searchname)
---------
	for skillIndex = 1, GetNumSkillLines() do
		skillName, isHeader, isExpanded, skillRank = GetSkillLineInfo(skillIndex)
		if isHeader == nil then
			if skillName == searchname then
				return skillRank
			end --if
		end --if
	end --for
end --function

---------
function GoGo_CheckCoOrds(ZoneName, SubZoneName)
---------
	local posX, posY = GetPlayerMapPosition("Player")
	local CanFlyHere = false
	local ZoneName = GoGo_FlyCoOrds[ZoneName]
	local SubZoneName = ZoneName[SubZoneName]
	for a = 1, table.getn(SubZoneName) or 0 do
		if GoGo_Variables.Debug then
			GoGo_DebugAddLine("GoGo_CheckCoOrds: Checking CoOrds " .. a)
		end --if
		local PointAX, PointAY, PointBX, PointBY = SubZoneName[a][1], SubZoneName[a][2], SubZoneName[a][3], SubZoneName[a][4]
		if posX >= PointAX and posX <= PointBX and posY >= PointAY and posY <= PointBY then
			-- we are in the rectangle a
			return true
		end --if
	end --for
	return false
end --function

---------
function GoGo_Msg(msg)
---------
	if msg then
		if GOGO_MESSAGES[msg] then
			GoGo_Msg(GOGO_MESSAGES[msg]())
		else
			msg = string.gsub(msg, "<", LIGHTYELLOW_FONT_COLOR_CODE)
			msg = string.gsub(msg, ">", "|r")
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE.."GoGo: |r"..msg)
		end --if
	end --if
end --function

---------
function GoGo_Id(itemstring)
---------
	local _, _, itemid = string.find(itemstring,"(item:%d+)")
	if itemid then
		return itemid.." - "..itemstring
	end --if
	local _, _, spellid = string.find(itemstring,"(spell:%d+)")
	if spellid then
		return spellid.." - "..itemstring
	end --if

end --function

GOGO_ERRORS = {
	[SPELL_FAILED_NOT_MOUNTED] = true,
	[SPELL_FAILED_NOT_SHAPESHIFT] = true,
	[ERR_ATTACK_MOUNTED] = true,
}

GOGO_SPELLS = {
	["DRUID"] = function()
		if GoGo_InBook(GoGo_Variables.Localize.AquaForm) then
			if not GoGo_Variables.SkipFlyingMount and GoGo_CanFly() and GoGo_InBook(GoGo_Variables.Localize.FastFlightForm) then
				return "[swimming] "..GoGo_InBook(GoGo_Variables.Localize.AquaForm).."; [combat]"..GoGo_InBook(GoGo_Variables.Localize.TravelForm).."; "..GoGo_InBook(GoGo_Variables.Localize.FastFlightForm)
			elseif not GoGo_Variables.SkipFlyingMount and GoGo_CanFly() and GoGo_InBook(GoGo_Variables.Localize.FlightForm) then
				return "[swimming] "..GoGo_InBook(GoGo_Variables.Localize.AquaForm).."; [combat]"..GoGo_InBook(GoGo_Variables.Localize.TravelForm).."; "..GoGo_InBook(GoGo_Variables.Localize.FlightForm)
			else
				return "[swimming] "..GoGo_InBook(GoGo_Variables.Localize.AquaForm).."; "..GoGo_InBook(GoGo_Variables.Localize.TravelForm)
			end --if
		end --if
	end, --function
	["SHAMAN"] = function()
		return GoGo_InBook(GoGo_Variables.Localize.GhostWolf)
	end, --function
}

GOGO_COMMANDS = {
	["auto"] = function()
		GoGo_Prefs.autodismount = not GoGo_Prefs.autodismount
		GoGo_Msg("auto")
		GoGo_Panel_UpdateViews()
	end, --function
	["genericfastflyer"] = function()
		if not GoGo_CanFly() then
			return
		else
			GoGo_Prefs.genericfastflyer = not GoGo_Prefs.genericfastflyer
			GoGo_Msg("genericfastflyer")
			GoGo_Panel_UpdateViews()
		end --if
	end, --function
	["clear"] = function()
		if GoGo_Prefs.GlobalPrefMount then
			GoGo_Prefs.GlobalPrefMounts = nil
			if not InCombatLockdown() then
				for i, button in ipairs({LuhUtilitiesMountButton, LuhUtilitiesMountButton2}) do
					GoGo_FillButton(button)
				end --for
			end --if
		else
			GoGo_Prefs[GoGo_Variables.Player.Zone] = nil
			if not InCombatLockdown() then
				for i, button in ipairs({LuhUtilitiesMountButton, LuhUtilitiesMountButton2}) do
					GoGo_FillButton(button)
				end --for
			end --if
		end --if
		GoGo_Msg("pref")
	end, --function
	["updatenotice"] = function()
		GoGo_Prefs.DisableUpdateNotice = not GoGo_Prefs.DisableUpdateNotice
		GoGo_Msg("updatenotice")
		GoGo_Panel_UpdateViews()
	end, --function
	["mountnotice"] = function()
		GoGo_Prefs.DisableMountNotice = not GoGo_Prefs.DisableMountNotice
		GoGo_Msg("mountnotice")
		GoGo_Panel_UpdateViews()
	end, --function
	["druidclickform"] = function()
		GoGo_Prefs.DruidClickForm = not GoGo_Prefs.DruidClickForm
		GoGo_Msg("druidclickform")
		GoGo_Panel_UpdateViews()
	end, --function
	["druidflightform"] = function()
		GoGo_Prefs.DruidFlightForm = not GoGo_Prefs.DruidFlightForm
		GoGo_Msg("druidflightform")
		GoGo_Panel_UpdateViews()
	end, --function
	["options"] = function()
		LS:ToggleUI()
		if LS.frame and LS.UI then
			LS.UI:ShowTab(LS.frame, "mount")
		end
	end, --function
}

GOGO_MESSAGES = {
	["auto"] = function()
		if GoGo_Prefs.autodismount then
			return "Autodismount active - </gogo auto> to toggle"
		else
			return "Autodismount inactive - </gogo auto> to toggle"
		end --if
	end, --function
	["genericfastflyer"] = function()
		if not GoGo_CanFly() then
			return
		elseif GoGo_Prefs.genericfastflyer then
			return "Considering epic flying mounts 310% - 280% speeds the same for random selection - </gogo genericfastflyer> to toggle"
		else
			return "Considering epic flying mounts 310% - 280% speeds different for random selection - </gogo genericfastflyer> to toggle"
		end --if
	end, --function
	["pref"] = function()
		local msg = ""
		if not GoGo_Prefs.GlobalPrefMount then
			local list = ""
			if GoGo_Prefs[GoGo_Variables.Player.Zone] then
				list = list .. GoGo_GetIDName(GoGo_Prefs[GoGo_Variables.Player.Zone])
				msg = GoGo_Variables.Player.Zone..": "..list.." - </gogo clear> to clear"
			else
				msg = GoGo_Variables.Player.Zone..": ?".." - </gogo ItemLink> or </gogo SpellName> to add"
			end --if
			if GoGo_Prefs.GlobalPrefMounts then
				list = list .. GoGo_GetIDName(GoGo_Prefs.GlobalPrefMounts)
				msg = msg .. "\nGlobal Preferred Mounts: "..list.." - Enable global mount preferences to change."
			end --if
			return msg
		else
			local list = ""
			if GoGo_Prefs.GlobalPrefMounts then
				list = list .. GoGo_GetIDName(GoGo_Prefs.GlobalPrefMounts)
				msg = "Global Preferred Mounts: "..list.." - </gogo clear> to clear"
			else
				msg =  "Global Preferred Mounts: ?".." - </gogo ItemLink> or </gogo SpellName> to add"
			end --if
			if GoGo_Prefs[GoGo_Variables.Player.Zone] then
				list = list .. GoGo_GetIDName(GoGo_Prefs[GoGo_Variables.Player.Zone])
				msg = msg .. "\n" .. GoGo_Variables.Player.Zone ..": "..list.." - Disable global mount preferences to change."
			end --if
			return msg
		end --if
	end, --function
	["updatenotice"] = function()
		if GoGo_Prefs.DisableUpdateNotice then
			return "Update notices from other players disabled - </gogo updatenotice> to toggle"
		else
			return "Update notices from other players enabled - </gogo updatenotice> to toggle"
		end --if
	end, --function
	["mountnotice"] = function()
		if GoGo_Prefs.DisableMountNotice then
			return "Update notices about unknown mounts are disabled - </gogo mountnotice> to toggle"
		else
			return "Update notices about unknown mounts are enabled - </gogo mountnotice> to toggle"
		end --if
	end, --function
	["druidclickform"] = function()
		if GoGo_Prefs.DruidClickForm then
			return "Single click form changes enabled - </gogo druidclickform> to toggle"
		else
			return "Single click form changes disabled - </gogo druidclickform> to toggle"
		end --if
	end, --function
	["druidflightform"] = function()
		if GoGo_Prefs.DruidFlightForm then
			return "Flight Forms always used over flying mounts - </gogo druidflightform> to toggle"
		else
			return "Flighing mounts selected, flight forms if moving - </gogo druidflightform> to toggle"
		end --if
	end, --function
	["UnknownMount"] = function() return GOGO_STRING_UNKNOWNMOUNTFOUND end, --function
	["optiongui"] = function() return "To open the GUI options window - </gogo options>" end, --function
}

---------

function GoGo_DebugAddLine()
end

function GoGo_Settings_Default()
	GoGo_Prefs.version = LS.VERSION
	GoGo_Prefs.autodismount = true
	GoGo_Prefs.DisableUpdateNotice = true
	GoGo_Prefs.DisableMountNotice = false
	GoGo_Prefs.genericfastflyer = false
	GoGo_Prefs.DruidClickForm = true
	GoGo_Prefs.DruidFlightForm = false
	GoGo_Prefs.UnknownMounts = GoGo_Prefs.UnknownMounts or {}
	GoGo_Prefs.GlobalPrefMounts = GoGo_Prefs.GlobalPrefMounts or {}
	GoGo_Prefs.GlobalPrefMount = false
	GoGo_Prefs.customLinesBefore = GoGo_Prefs.customLinesBefore or {}
	GoGo_Prefs.customLinesAfter = GoGo_Prefs.customLinesAfter or {}
end

function GoGo_Settings_SetUpdates()
	GoGo_Prefs.version = LS.VERSION
	GoGo_Prefs.UnknownMounts = GoGo_Prefs.UnknownMounts or {}
	GoGo_Prefs.customLinesBefore = GoGo_Prefs.customLinesBefore or {}
	GoGo_Prefs.customLinesAfter = GoGo_Prefs.customLinesAfter or {}
end

function GoGo_Panel_Options()
end

function GoGo_Panel_UpdateViews()
	local frame = LuhUtilitiesMountFrame
	if not frame or not GoGo_Prefs then
		return
	end
	if GoGo_Prefs.autodismount then
		frame:RegisterEvent("UI_ERROR_MESSAGE")
	else
		frame:UnregisterEvent("UI_ERROR_MESSAGE")
	end
	if LS.RefreshMountUI then
		LS:RefreshMountUI()
	end
end

function LS:InitMount()
    if self.mountInitialized then
        return
    end
    self.mountInitialized = true
    if not self.db.mount then
        self.db.mount = {}
    end
    LS.CopyDefaults(LS.mountDefaults, self.db.mount)
    GoGo_Prefs = self.db.mount
    if not GoGo_Prefs.UnknownMounts then
        GoGo_Prefs.UnknownMounts = {}
    end
    if not GoGo_Prefs.GlobalPrefMounts then
        GoGo_Prefs.GlobalPrefMounts = {}
    end
    if not GoGo_Prefs.customLinesBefore then
        GoGo_Prefs.customLinesBefore = {}
    end
    if not GoGo_Prefs.customLinesAfter then
        GoGo_Prefs.customLinesAfter = {}
    end
    MV.MountDB = LS.MountDB
    if LuhUtilitiesMountFrame then
        GoGo_OnLoad(LuhUtilitiesMountFrame)
    end
    if UnitName("player") then
        GoGo_DoPlayerEnteringWorld()
    end
    self:UpdateMountBindings()
end

function LS:UpdateMountBindings()
    if InCombatLockdown() then
        return
    end
    GoGo_CheckBindings()
end

function LS:Trim(s)
    if not s then return "" end
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function LS:BuildMountMacroText(mountText)
    local lines = {}
    local prefs = self.db.mount
    if prefs.customLinesBefore then
        for _, line in ipairs(prefs.customLinesBefore) do
            line = self:Trim(line)
            if line ~= "" then
                table.insert(lines, line)
            end
        end
    end
    if mountText and mountText ~= "" then
        mountText = tostring(mountText)
        if mountText:find("[%[%;]") then
            table.insert(lines, "/cast " .. mountText)
        elseif mountText:find(",") then
            for part in string.gmatch(mountText, "[^,]+") do
                part = self:Trim(part)
                if part ~= "" then
                    table.insert(lines, "/use " .. part)
                end
            end
        else
            table.insert(lines, "/use " .. mountText)
        end
    end
    if prefs.customLinesAfter then
        for _, line in ipairs(prefs.customLinesAfter) do
            line = self:Trim(line)
            if line ~= "" then
                table.insert(lines, line)
            end
        end
    end
    if #lines == 0 then
        return nil
    end
    return table.concat(lines, "\n")
end

function LS:AddMountFavorite(spellOrItemId)
    spellOrItemId = tonumber(spellOrItemId)
    if not spellOrItemId then
        return false, "Invalid mount id."
    end
    GoGo_AddPrefMount(spellOrItemId)
    return true
end

function LS:ClearMountFavorites()
    if GoGo_Prefs.GlobalPrefMount then
        GoGo_Prefs.GlobalPrefMounts = {}
    else
        GoGo_Prefs[GetRealZoneText()] = nil
    end
    if not InCombatLockdown() then
        for _, button in ipairs({ LuhUtilitiesMountButton, LuhUtilitiesMountButton2, LuhUtilitiesMountButton3 }) do
            if button then
                GoGo_FillButton(button)
            end
        end
    end
end
