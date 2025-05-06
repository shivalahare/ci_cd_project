from django.test import TestCase, Client
from django.urls import reverse

class HomeViewTest(TestCase):
    def setUp(self):
        # Setup runs before each test method
        self.client = Client()
        self.home_url = reverse('home')
    
    def test_home_page_status_code(self):
        # Test that home page returns a 200 status code
        response = self.client.get(self.home_url)
        self.assertEqual(response.status_code, 200)
    
    def test_home_page_template(self):
        # Test that the correct template is used
        response = self.client.get(self.home_url)
        self.assertTemplateUsed(response, 'home.html')
