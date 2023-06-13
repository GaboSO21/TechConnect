from django.views.generic.base import TemplateView
from django.shortcuts import render

# Generic class view
class HomePageView(TemplateView):

    # Stablish template to return
    template_name = 'core/home.html'

    # Function to return context
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['title']  = 'TechConnect'
        return context

    # Mismo que arriba pero con render
    def get(self, request, *args, **kwargs):
        return render(request, self.template_name, {'title': 'TechConnect'})


class SamplePageView(TemplateView):

    template_name = 'core/sample.html'
