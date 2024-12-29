const fs = require('fs/promises');
const baseUrl = 'https://www.nytimes.com/svc/wordle/v2/';
const addZeroToStartIfNeeded = (n) => (n < 10 ? '0' + String(n) : String(n));
const getFileName = () => {
    const d = new Date();
    const month = d.getMonth() + 1;
    return `${d.getFullYear()}-${addZeroToStartIfNeeded(month)}-${addZeroToStartIfNeeded(d.getDate())}.json`;
};
const getResult = async (url) => await (await fetch(url)).text();
const doDate = async () => {
    const result = await getResult(baseUrl.concat(getFileName()));
    if (!result.includes('404')) await fs.writeFile('./answers/' + getFileName(), result, 'utf-8');
};
const main = async () => {
    await doDate();
};
main();
