// Telegram Daily Quote Agent
// Deployment: Railway.app
// Bot Token: 8834123524:AAEbkbkCma7ytq7uyw-FsNwvEYBvOn4Lftw

const TelegramBot = require('node-telegram-bot-api');
const cron = require('node-cron');

// Get from environment variables (set in Railway)
const token = process.env.TELEGRAM_TOKEN || '8834123524:AAEbkbkCma7ytq7uyw-FsNwvEYBvOn4Lftw';
let CHAT_ID = process.env.CHAT_ID;

// Initialize bot
const bot = new TelegramBot(token, { polling: true });

// Positive quotes database
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

// Function to get random quote
function getRandomQuote() {
  return quotes[Math.floor(Math.random() * quotes.length)];
}

// Function to send quote
async function sendQuote(chatId) {
  try {
    const quote = getRandomQuote();
    const message = `Good morning! 🌅\n\n${quote}\n\nHave an amazing day ahead! 💪`;
    await bot.sendMessage(chatId, message);
    console.log(`✅ Quote sent at ${new Date().toLocaleString('en-US', { timeZone: 'America/New_York' })}`);
  } catch (error) {
    console.error('❌ Error sending quote:', error.message);
  }
}

// Function to send test message
async function sendTestMessage(chatId) {
  try {
    const message = `🧪 Test message sent at ${new Date().toLocaleString('en-US', { timeZone: 'America/New_York' })} Eastern Time\n\nYour Telegram Quote Agent is working!`;
    await bot.sendMessage(chatId, message);
    console.log(`✅ Test message sent at ${new Date().toLocaleString('en-US', { timeZone: 'America/New_York' })}`);
  } catch (error) {
    console.error('❌ Error sending test message:', error.message);
  }
}

// Listen for /start command to get chat ID
bot.onText(/\/start/, (msg) => {
  const chatId = msg.chat.id;
  const username = msg.chat.username || 'Unknown';
  
  // Store the chat ID for future use
  CHAT_ID = chatId;
  
  bot.sendMessage(chatId, `✅ Connected!\n\nYour Chat ID: ${chatId}\nUsername: @${username}\n\n⏰ Quotes will be sent at:\n• 7:30 AM ET (daily)\n• 12:25 PM ET (test)\n\n/quote - Get a random quote now\n/test - Send test message now`);
  
  console.log(`👤 User connected: @${username} (ID: ${chatId})`);
});

// Listen for /quote command
bot.onText(/\/quote/, (msg) => {
  const chatId = msg.chat.id;
  sendQuote(chatId);
});

// Listen for /test command
bot.onText(/\/test/, (msg) => {
  const chatId = msg.chat.id;
  sendTestMessage(chatId);
});

// Scheduler - 7:30 AM Eastern Time (daily)
cron.schedule('30 7 * * *', () => {
  console.log('⏰ Running 7:30 AM daily quote...');
  if (CHAT_ID) {
    sendQuote(CHAT_ID);
  }
}, { timezone: 'America/New_York' });

// Scheduler - 12:25 PM Eastern Time (daily for testing)
cron.schedule('25 12 * * *', () => {
  console.log('⏰ Running 12:25 PM test message...');
  if (CHAT_ID) {
    sendTestMessage(CHAT_ID);
  }
}, { timezone: 'America/New_York' });

console.log('🤖 Telegram Quote Agent is running...');
console.log('📋 Commands:');
console.log('   /start - Register and get your Chat ID');
console.log('   /quote - Get a random quote now');
console.log('   /test - Send test message now');
console.log('\n⏰ Scheduled times (Eastern):');
console.log('   7:30 AM - Daily positive quote');
console.log('   12:25 PM - Test message');
console.log('\n🚀 Agent is active and listening...\n');
