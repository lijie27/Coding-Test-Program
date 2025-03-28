document.addEventListener('DOMContentLoaded', () => {
    let numPeopleInput = document.getElementById('numPeople');
    let distributeBtn = document.getElementById('distributeBtn');
    let resultContainer = document.getElementById('distributionResult');
    let errorContainer = document.getElementById('errorContainer');

    distributeBtn.addEventListener('click', distributeCards);

    async function distributeCards() {
        // Clear previous results
        resultContainer.innerHTML = '';
        errorContainer.innerHTML = '';
        
        let numPeople = parseInt(numPeopleInput.value);

        // Call backend
        try {
            let response = await fetch(`../backend/distributionAPI.php?numPeople=${numPeople}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            let data = await response.json();

            // Show error msg if not success,for example if numPeople <= 0
            if (!data.success) {
                throw new Error(data.message);
            }

            // Display results
            data.distribution.forEach((cards, index) => {
                let personDiv = document.createElement('div');
                personDiv.className = 'person-cards';
                personDiv.innerHTML = `<strong>Person ${index + 1}:</strong> ${cards}`;
                resultContainer.appendChild(personDiv);
            });
        } catch (error) {
            errorContainer.textContent = error.message;
            console.error("Error:", error);
        }
    }
});