---
title: "Reverse engineering Roots of Pacha"
date: "2025-02-01"
categories: ["hacking", "reversing", "gaming"]
---
# A Gamer's Journey into Kickstarter Codes

Hey there, fellow gamers! Today, I want to share with you a little adventure I embarked on while exploring the depths of [Roots of Pacha](https://rootsofpacha.com), an indie farm simulation game set in prehistoric times. This isn’t just about gaming—it’s about curiosity, problem-solving, and a bit of reverse engineering. So buckle up, because we’re diving into some code sleuthing!

I backed this game during its [Kickstarter](https://www.kickstarter.com/projects/sodaden/roots-of-pacha) campaign and I received two copies of the game along with exclusive reward codes that unlocked special content. Here’s where things got interesting:

> Despite having **two separate** copies, I received the **same reward code** for both.

This raised a red flag. Were these codes static based on the tier of rewards? Could there be more hidden treasures waiting to be discovered? I mean, if they make it that easy, who could refuse?

## Hidden content 🕵️‍♂️

To start my investigation, I needed the right tools. Enter [ILSpy](https://github.com/icsharpcode/ILSpy), a powerful .NET decompiler that allows you to peek under the hood of compiled programs.

Once everything was set up, I loaded the `Assembly-CSharp.dll` file from the game directory (`\Program Files (x86)\Steam\steamapps\common\Roots of Pacha\Roots of Pacha_Data`) into ILSpy. With the file open, I was ready to dig deep into the game’s inner workings.

---

The first step was searching for keywords within the code, such as `key`, `code`, and `redeem`. After sifting through countless lines of code, I stumbled upon something intriguing—a static class called `RedeemableCodes`. Inside this class, I found several encoded strings in base64 format:

```csharp
public static class RedeemableCodes
{
    public static readonly string HouseEncoded = "SzFDS1NUNFJUM1)fSE9V";
    public static readonly string BoarEncoded = "SzFDS1NUNFJUM1JfQk9B";
    public static readonly string OstrichEncoded = "SzFDS1NUNFJUM1)fTINU";
    public static readonly string BearEncoded = "SzFDS1NUNFJUM1JfQkVB";
    public static readonly string BackerStoneEncoded = "SzFDS1NUNFJUM1)fQINP";
    public static string House => Decode(HouseEncoded);
    public static string Boar => Decode(BoarEncoded);
    public static string Ostrich => Decode(OstrichEncoded);
    public static string Bear => Decode(BearEncoded);
    public static string BackerStone = Decode(BackerStoneEncoded);
    public static string Wolf => Decode("SDAwMFdM");
    public static string Encode(string input) { ... }
    public static string Decode(string input) { ... }
}
```

Decoding them revealed patterns like `K1CKST4RT3R_`, which seemed promising:

```csharp
... string HouseEncoded = "SzFDS1NUNFJUM1JfSE9V"; // K1CKST4RT3R_HOU
... string BoarEncoded = "SzFDS1NUNFJUM1JfQk9B"; // K1CKST4RT3R_BOA
... string OstrichEncoded = "SzFDS1NUNFJUM1JfT1NU"; // K1CKSTST4RT3R_OST
... string BearEncoded = "SzFDS1NUNFJUM1JfQkVB"; // K1CKSTST4RT3R_BEA
... string BackerStoneEncoded = "SzFDS1NUNFJUM1JfQlNP"; // K1CKSTST4RT3R_BSO
```

However, when I tried entering these codes in-game, they didn’t work. Turns out, these weren’t the actual Kickstarter codes but rather some kind of placeholders or mock values.

It is worth noting that another of the base64 codes did look promising:

```csharp
... string Wolf => Decode("SDAwMFdM"); // H000WL
```

Unlike the others, this one did not follow the `K1CKST4RT3R_` pattern. Out of curiosity, I entered `H000WL` into the game.... and voilà! 🎉 It worked!

![H00WL](/images/hacking-rootsofpacha.png)

This mysterious code granted me a wolf skin for my character, reminiscent of [Okka](https://rootsofpacha.fandom.com/wiki/Okka), the legendary wolf of Norse mythology and kind resident of my village in Pacha. Isn't it cool?

## A stone wall 🗿

Next, I wanted to figure out how the rest of the codes were validated. Using ILSpy’s analysis feature, I traced references to the `RedeemableCodes` class and landed on the `MoveNext` method inside `<OnCodeInput>d__149` (`SodaDen.Pacha.UI.MM.SystemSubcategoryContent`). Here’s what it looked like:

```csharp
<error>5__5 = false;
<invalidCode>5__6 = false;
<codeResult>5__7 = null;
if (result == RedeemableCodes.Wolf).
{
	<codeResult>5__7 = "Wolf";
	goto IL_0400;
}
<webRequest>5__8 = UnityWebRequest.Get("https://us-central1-roots-of-pacha-pledgebox.cloudfunctions.net/orders/validate-code?code=" + result.Replace("-", ""));
goto IL_02b0;
```

This snippet showed that any code other than `RedeemableCodes.Wolf` was verified online via an API endpoint. Testing invalid codes returned a predictable `400 Bad Request` response, while valid ones returned identifiers linked to specific rewards.

Unfortunately, brute-forcing the remaining codes wasn’t feasible due to the sheer number of possibilities (over **4 quintillion combinations**!) and ethical concerns. Attempting unauthorized access to servers is not only illegal but also disrespectful to the developers who created this fantastic game.

## The End? 🥷🏻

Finding the `H000WL` code was undoubtedly a thrilling discovery. While it didn’t grant me all the Kickstarter rewards, it highlighted an oversight in the development process—this particular code bypassed the usual API validation, suggesting it might have been added hastily.

**But don't think that a simple API validation prevented me from getting the rest of the rewards!** Maybe in another post I will explain you how using [mitmproxy](https://mitmproxy.org/) I was able to fake the API responses.

It is also true that the developers have shared some code since I did this little research on release day (indeed, this is an old article). [Here](https://rootsofpacha.com/festival/) are some of them:

- **Bunny Hat**: `LILBUNNY`
- **Golden Pomegranate**: `ELDORADO`
- **Pacheems Statue**: `PACH33MS`

## Bonus 🎁

It has been a year and a half since the game was launched. If you were a baker on Kickstarter, by accessing [this link](https://rootsofpacha.com/orders/) you could get your baker code with your reward. This is the one I received:

- `79MD-48YV-4XX9`