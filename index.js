const TelegramBot = require('node-telegram-bot-api');

const token = '8834123524:AAEbkbkCma7ytq7uyw-FsNwvEYBvOn4Lftw';
const bot = new TelegramBot(token, { polling: true });

let userChatId = null;

const quotes = [
  "🌟 The only way to do great work is to love what you do. - Steve Jobs",
  "💪 Success is not final, failure is not fatal. It is the courage to continue that counts. - Winston Churchill",
  "🚀 Don't watch the clock; do what it does. Keep going. - Sam Levenson",
  "🎯 The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  "✨ You are capable of amazing things. Believe in yourself.",
  "🔥 Every accomplishment starts with the decision to try. - John F. Kennedy",
  "💎 The only impossible journey is the one you never begin. - Tony Robbins",
  "🌈 Your limitation—it's only your imagination. Push harder.",
  "⚡ Success is walking from failure to failure with no loss of enthusiasm. - Winston Churchill",
  "🏆 You don't have to be great to start, but you have to start to be great. - Zig Ziglar",
  "🌺 Progress over perfection. Keep moving forward.",
  "💫 The best time to plant a tree was 20 years ago. The second best time is now.",
  "🎨 Be yourself; everyone else is already taken. - Oscar Wilde",
  "🔑 Your potential is endless. Your only limit is you.",
  "🌟 Wake up with determination. Go to bed with satisfaction.",
];

function getRandomQuote() {
  return quotes[Math.floor(Math.random() * quotes.length)];
}

function sendDailyQuote() {
  if (userChatId) {
    const quote = getRandomQuote();
    const message = `Good morning! 🌅\n\n${quote}\n\nHave an amazing day! 💪`;
    bot.sendMessage(userChatId, message);
    console.log('Daily quote sent');
  }
}

// Check time every minute and send quote at 7:30 AM
setInterval(() => {
  const now = new Date();
  const hours = now.getHours();
  const minutes = now.getMinutes();
  
  if (hours === 7 && minutes === 30) {
    sendDailyQuote();
  }
}, 60000);

bot.onText(/\/start/, (msg) => {
  userChatId = msg.chat.id;
  const message = `✅ Connected!\n\nQuotes will be sent at 7:30 AM ET\n\nCommands:\n/quote - Get a random quote now\n/test - Test message`;
  bot.sendMessage(userChatId, message);
});

bot.onText(/\/quote/, (msg) => {
  const chatId = msg.chat.id;
  const quote = getRandomQuote();
  bot.sendMessage(chatId, `🌅 ${quote}\n\nHave an amazing day! 💪`);
});

bot.onText(/\/test/, (msg) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, `🧪 Bot is working!`);
});

bot.on('polling_error', (error) => {
  console.log('Error:', error.code);
});

console.log('Bot running');
